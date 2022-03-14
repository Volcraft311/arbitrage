local PLUGIN = PLUGIN


hook._profiler_old_call = hook._profiler_old_call or hook.Call

local metrics = {}
local counts = {}


function hook.Call(name, gm, ...)
  local start_time = os.clock()
  local total_time = metrics[name] or 0

  local a, b, c, d, e, f = hook._profiler_old_call(name, gm, ...)

  metrics[name] = total_time + (os.clock() - start_time)
  counts[name] = (counts[name] or 0) + 1

  return a, b, c, d, e, f
end

if CLIENT then
    local total_cl = 0
    local total_sv = 0
    local largest_cl = 'not measured yet'
    local largest_sv = 'not measured yet'
    local largest_cl_n = 0
    local largest_sv_n = 0
    local metrics_sv = {}
    local counts_sv = {}
    local debug_color = Color(200, 100, 100, 200)
  
    netstream.Hook('fl_profiler_update', function(metrics_data, counts_data)
      metrics_sv = metrics_data
      counts_sv = counts_data
      total_sv = 0
      total_cl = 0
      largest_cl_n = 0
      largest_sv_n = 0
  
      for k, v in pairs(metrics_sv) do
        total_sv = total_sv + v
  
        if v > largest_sv_n then
          largest_sv_n = v
          largest_sv = k
        end
      end
  
      for k, v in pairs(metrics) do
        total_cl = total_cl + v
  
        if v > largest_cl_n then
          largest_cl_n = v
          largest_cl = k
        end
      end
  
      if IsValid(PLUGIN.panel) then
        PLUGIN.panel:update_metrics(PLUGIN:get_metrics())
      end
  
      metrics = {}
      counts = {}
    end)
  
    function PLUGIN:get_metrics()
      return metrics, counts, metrics_sv, counts_sv
    end
  
    function PLUGIN:HUDProfiler()
      if !SETTINGS.options.Get("show_profiler_info") then return end

      local pos = ScrH() - 30
  
      draw.SimpleText('SV: '..tostring(math.Round(total_sv * 1000, 2))..'ms', 'default', 8, pos - 36, debug_color)
      draw.SimpleText(largest_sv..' ('..tostring(math.Round(largest_sv_n * 1000, 2))..'ms)', 'default', 8, pos - 24, debug_color)
      draw.SimpleText('CL: '..tostring(math.Round(total_cl * 1000, 2))..'ms', 'default', 8, pos - 12, debug_color)
      draw.SimpleText(largest_cl..' ('..tostring(math.Round(largest_cl_n * 1000, 2))..'ms)', 'default', 8, pos, debug_color)
    end
  
    local PANEL = {}
  
    PANEL.metrics = {}
    PANEL.counts = {}
    PANEL.metrics_sv = {}
    PANEL.counts_sv = {}
    PANEL.lines = {}
  
    function PANEL:Init()
      self:rebuild()
    end
  
    function PANEL:update_metrics(metrics, counts, metrics_sv, counts_sv)
      self.metrics, self.counts, self.metrics_sv, self.counts_sv = metrics, counts, metrics_sv, counts_sv
      self:rebuild()
    end
  
    function PANEL:rebuild()
      if !IsValid(self.sv_list) then
        self.sv_list = vgui.Create('DListView', self)
        self.sv_list:Dock(FILL)
        self.sv_list:AddColumn('Hook')
        self.sv_list:AddColumn('Load')
        self.sv_list:AddColumn('Calls')
        self.sv_list:AddColumn('Side')
      end
  
      for k, v in pairs(self.metrics_sv) do
        local line = PANEL.lines[k .. "sv"]
  
        if !IsValid(line) then
          PANEL.lines[k .. "sv"] = self.sv_list:AddLine(k .. " (SV)", tostring(math.Round(v * 1000, 2))..'ms', self.counts_sv[k], "Server")
        else
          line:SetValue(1, k .. " (SV)")
          line:SetValue(2, tostring(math.Round(v * 1000, 2))..'ms')
          line:SetValue(3, self.counts_sv[k])
          line:SetValue(4, "Server")
        end
      end

      for k, v in pairs(self.metrics) do
        local line = PANEL.lines[k .. "cl"]
  
        if !IsValid(line) then
          PANEL.lines[k .. "cl"] = self.sv_list:AddLine(k .. " (CL)", tostring(math.Round(v * 1000, 2))..'ms', self.counts[k], "Client")
        else
          line:SetValue(1, k .. " (CL)")
          line:SetValue(2, tostring(math.Round(v * 1000, 2))..'ms')
          line:SetValue(3, self.counts[k])
          line:SetValue(4, "Client")
        end
      end
    end
  
    vgui.Register('profiler_window', PANEL, "DFrame")
  
    concommand.Add('fl_profiler_toggle', function()
        if !IsValid(PLUGIN.panel) then
          local scrw, scrh = ScrW(), ScrH()
          local pw, ph = scrw * 0.5, scrh * 0.5
  
          PLUGIN.panel = vgui.Create('profiler_window')
          PLUGIN.panel:SetSize(pw, ph)
          PLUGIN.panel:SetPos(scrw * 0.5 - pw * 0.5, scrh * 0.5 - ph * 0.5)
          PLUGIN.panel:SetVisible(false)
        end
  
        if PLUGIN.panel:IsVisible() then
            PLUGIN.panel:SetVisible(false)
            PLUGIN.panel:SetKeyboardInputEnabled(false)
            PLUGIN.panel:SetMouseInputEnabled(false)
        else
            PLUGIN.panel:SetVisible(true)
            PLUGIN.panel:MakePopup()
        end
    end)
  else
    timer.Create('fl_profiler_update', 1, 0, function()
      netstream.Start(nil, 'fl_profiler_update', metrics, counts)

      metrics = {}
      counts = {}
    end)
  end