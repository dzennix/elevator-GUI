
function elevatortesting()

    fig = figure('Name', 'Smart Elevator Control System v2.0', ...
                 'NumberTitle', 'off', ...
                 'Position', [50, 50, 1350, 750], ...
                 'Color', [0.96 0.96 0.96], ...
                 'Resize', 'on');

    handles = struct();
    handles.current_floor = 0;
    handles.target_floor = 0;
    handles.is_moving = false;
    handles.direction = 'STOP';
    handles.door_open = true;
    handles.emergency_mode = false;
    handles.radio_playing = false;
    handles.lights_on = true;
    handles.weight = 0;
    handles.motion_sensor = false;
    handles.floor_requests = [];
    handles.move_step = 0;
    handles.total_steps = 0;
    handles.weight_limit_exceeded = false;
    handles.energy_saving_mode = false;
    handles.active_emergency = 'none';
    handles.earthquake_magnitude = 0;

    % DAY OF WEEK SYSTEM
    handles.current_day = 4;
    handles.day_names = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'};
    handles.is_sunday = false;
    handles.weekend_energy_boost = false;
    handles.system_disabled = false;

    % TIME SYSTEM
    handles.current_hour = 7;
    handles.current_minute = 0;
    handles.time_speed = 5;
    handles.time_running = true;
    handles.base_floor_time = 4;

    % FEEDBACK SYSTEM
    handles.feedback_url = 'https://forms.gle/EXAMPLE1234567890';
    handles.feedback_count = 0;
    handles.customer_complaints = 0;
    handles.customer_compliments = 0;
    handles.song_requests = {};
    handles.feature_requests = {};

    % DEFINE COLOR SCHEME IN HANDLES
    handles.colors.bg_main = [0.96 0.96 0.96];
    handles.colors.panel_bg = [0.98 0.98 0.98];
    handles.colors.pastel_blue = [0.85 0.92 1];
    handles.colors.pastel_green = [0.85 1 0.92];
    handles.colors.pastel_purple = [0.95 0.85 1];
    handles.colors.pastel_yellow = [1 1 0.85];
    handles.colors.pastel_orange = [1 0.92 0.85];
    handles.colors.pastel_pink = [1 0.85 0.95];
    handles.colors.dark_gray = [0.3 0.3 0.3];
    handles.colors.light_gray = [0.9 0.9 0.9];
    handles.colors.emergency_red = [1 0.3 0.3];
    handles.colors.warning_orange = [1 0.6 0.2];
    handles.colors.safe_green = [0.3 0.8 0.3];
    handles.colors.info_blue = [0.3 0.6 1];
    handles.colors.fire_orange = [1 0.5 0.2];
    handles.colors.flood_blue = [0.3 0.7 0.9];
    handles.colors.earthquake_brown = [0.7 0.5 0.3];

    % Radio songs
    handles.radio_songs = {
        'Classical - Beethoven',
        'Jazz - Smooth',
        'Pop - Top Hits',
        'Ambient - Elevator Music',
        'Rock - Classic Rock',
        'Electronic - LoFi'
    };
    handles.current_song = 1;

    guidata(fig, handles);

    panel_elevator = uipanel('Parent', fig, 'Title', '🚪 Elevator Interior', ...
                            'Position', [0.02, 0.05, 0.25, 0.9], ...
                            'BackgroundColor', handles.colors.pastel_blue, ...
                            'FontSize', 11, 'FontWeight', 'bold', ...
                            'ForegroundColor', handles.colors.dark_gray);

    panel_control = uipanel('Parent', fig, 'Title', '🔼 Floor Control Panel', ...
                           'Position', [0.28, 0.05, 0.15, 0.9], ...
                           'BackgroundColor', handles.colors.pastel_purple, ...
                           'FontSize', 11, 'FontWeight', 'bold', ...
                           'ForegroundColor', handles.colors.dark_gray);

    panel_status = uipanel('Parent', fig, 'Title', '📊 Elevator Status', ...
                          'Position', [0.44, 0.6, 0.54, 0.35], ...
                          'BackgroundColor', handles.colors.pastel_green, ...
                          'FontSize', 11, 'FontWeight', 'bold', ...
                          'ForegroundColor', handles.colors.dark_gray);

    panel_emergency = uipanel('Parent', fig, 'Title', '⚠️ Emergency Control', ...
                             'Position', [0.44, 0.35, 0.26, 0.2], ...
                             'BackgroundColor', handles.colors.pastel_orange, ...
                             'FontSize', 11, 'FontWeight', 'bold', ...
                             'ForegroundColor', handles.colors.dark_gray);

    panel_radio = uipanel('Parent', fig, 'Title', '🎵 Radio System', ...
                         'Position', [0.44, 0.15, 0.26, 0.15], ...
                         'BackgroundColor', handles.colors.pastel_pink, ...
                         'FontSize', 11, 'FontWeight', 'bold', ...
                         'ForegroundColor', handles.colors.dark_gray);

    panel_day_system = uipanel('Parent', fig, 'Title', '📅 Day & Schedule', ...
                              'Position', [0.72, 0.35, 0.26, 0.2], ...
                              'BackgroundColor', handles.colors.pastel_yellow, ...
                              'FontSize', 11, 'FontWeight', 'bold', ...
                              'ForegroundColor', handles.colors.dark_gray);

    panel_feedback = uipanel('Parent', fig, 'Title', '💬 Customer Feedback', ...
                            'Position', [0.72, 0.15, 0.26, 0.15], ...
                            'BackgroundColor', handles.colors.pastel_blue, ...
                            'FontSize', 11, 'FontWeight', 'bold', ...
                            'ForegroundColor', handles.colors.dark_gray);

    % Door status section
    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', '🚪 DOOR STATUS:', ...
             'Position', [20, 600, 120, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.door_indicator = uicontrol('Parent', panel_elevator, 'Style', 'pushbutton', ...
                                      'String', '🟢 OPEN', 'Position', [150, 600, 100, 25], ...
                                      'FontSize', 10, 'FontWeight', 'bold', ...
                                      'BackgroundColor', handles.colors.safe_green, ...
                                      'ForegroundColor', [0 0 0]);

    % Motion sensor section
    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', '👁️ MOTION SENSOR:', ...
             'Position', [20, 560, 120, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.motion_indicator = uicontrol('Parent', panel_elevator, 'Style', 'pushbutton', ...
                                        'String', '🔴 NO MOTION', 'Position', [150, 560, 100, 25], ...
                                        'FontSize', 9, 'FontWeight', 'bold', ...
                                        'BackgroundColor', handles.colors.emergency_red, ...
                                        'Callback', {@toggle_motion_sensor, fig});

    % Weight display section
    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', '⚖️ CURRENT WEIGHT:', ...
             'Position', [20, 520, 130, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.weight_display = uicontrol('Parent', panel_elevator, 'Style', 'text', ...
                                      'String', sprintf('%d / 800 kg', handles.weight), ...
                                      'Position', [160, 520, 90, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
                                      'BackgroundColor', [1 1 1], 'ForegroundColor', [0 0 0]);

    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', 'Simulate Weight:', ...
             'Position', [20, 490, 120, 25], 'FontSize', 9, ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.weight_slider = uicontrol('Parent', panel_elevator, 'Style', 'slider', ...
                                     'Min', 0, 'Max', 900, 'Value', handles.weight, ...
                                     'Position', [20, 460, 230, 25], ...
                                     'BackgroundColor', handles.colors.light_gray, ...
                                     'Callback', {@update_weight, fig});

    % Lights status section
    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', '💡 LIGHTS STATUS:', ...
             'Position', [20, 420, 120, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.light_indicator = uicontrol('Parent', panel_elevator, 'Style', 'pushbutton', ...
                                       'String', '🟡 AUTO: ON', 'Position', [150, 420, 100, 25], ...
                                       'FontSize', 9, 'FontWeight', 'bold', ...
                                       'BackgroundColor', [1 1 0.7]);

    % Energy saving mode button
    handles.no_passengers_button = uicontrol('Parent', panel_elevator, 'Style', 'pushbutton', ...
                                            'String', '🔋 NO PASSENGERS MODE', 'Position', [20, 370, 230, 40], ...
                                            'FontSize', 10, 'FontWeight', 'bold', ...
                                            'BackgroundColor', handles.colors.dark_gray, 'ForegroundColor', [1 1 1], ...
                                            'Callback', {@toggle_energy_saving, fig});

    % Requested floors display
    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', '📋 REQUESTED FLOORS:', ...
             'Position', [20, 320, 180, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    uicontrol('Parent', panel_elevator, 'Style', 'text', 'String', 'Next stops:', ...
             'Position', [20, 290, 80, 25], 'FontSize', 9, ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.request_numbers_display = uicontrol('Parent', panel_elevator, 'Style', 'text', ...
                                               'String', 'None', 'Position', [20, 200, 230, 90], ...
                                               'FontSize', 18, 'FontWeight', 'bold', ...
                                               'BackgroundColor', handles.colors.dark_gray, 'ForegroundColor', handles.colors.safe_green, ...
                                               'HorizontalAlignment', 'center');

    %% Control Panel
    floors = [-1, 0, 1, 2, 3];
    floor_button_positions = [40, 450; 40, 370; 40, 290; 40, 210; 40, 130];
    floor_button_colors = [0.8 0.9 1; 0.9 0.8 1; 0.8 1 0.9; 1 0.9 0.8; 0.9 1 0.8];

    for i = 1:5
        uicontrol('Parent', panel_control, 'Style', 'pushbutton', ...
                 'String', sprintf('Floor %d', floors(i)), ...
                 'Position', [floor_button_positions(i,1), floor_button_positions(i,2), 90, 70], ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'BackgroundColor', floor_button_colors(i,:), ...
                 'ForegroundColor', handles.colors.dark_gray, ...
                 'Callback', {@floor_button_callback, floors(i), fig});
    end

    uicontrol('Parent', panel_control, 'Style', 'pushbutton', 'String', '🚪 OPEN DOOR', ...
             'Position', [40, 80, 90, 35], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.safe_green, 'ForegroundColor', [0 0 0], ...
             'Callback', {@open_door, fig});

    uicontrol('Parent', panel_control, 'Style', 'pushbutton', 'String', '🚪 CLOSE DOOR', ...
             'Position', [40, 35, 90, 35], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.warning_orange, 'ForegroundColor', [0 0 0], ...
             'Callback', {@close_door, fig});

    %% Status Display
    uicontrol('Parent', panel_status, 'Style', 'text', 'String', '📍 CURRENT FLOOR:', ...
             'Position', [30, 200, 140, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_green, 'HorizontalAlignment', 'left');

    handles.floor_display = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                     'String', 'Floor 0', 'Position', [180, 200, 120, 30], ...
                                     'FontSize', 20, 'FontWeight', 'bold', ...
                                     'BackgroundColor', handles.colors.dark_gray, 'ForegroundColor', handles.colors.safe_green);

    handles.direction_indicator = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                           'String', '●', 'Position', [310, 200, 50, 30], ...
                                           'FontSize', 24, 'FontWeight', 'bold', ...
                                           'BackgroundColor', handles.colors.pastel_green, 'ForegroundColor', handles.colors.dark_gray);

    % Target floor display
    uicontrol('Parent', panel_status, 'Style', 'text', 'String', '🎯 TARGET FLOOR:', ...
             'Position', [30, 160, 140, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_green, 'HorizontalAlignment', 'left');

    handles.target_display = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                      'String', 'Floor 0', 'Position', [180, 160, 120, 30], ...
                                      'FontSize', 16, 'FontWeight', 'bold', ...
                                      'BackgroundColor', [1 1 1], 'ForegroundColor', handles.colors.info_blue);

    % Time display
    uicontrol('Parent', panel_status, 'Style', 'text', 'String', '🕒 TIME:', ...
             'Position', [370, 160, 80, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_green, 'HorizontalAlignment', 'left');

    handles.time_display = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                    'String', '07:00', 'Position', [450, 160, 100, 30], ...
                                    'FontSize', 18, 'FontWeight', 'bold', ...
                                    'BackgroundColor', handles.colors.dark_gray, 'ForegroundColor', [1 1 1]);

    % Day display
    uicontrol('Parent', panel_status, 'Style', 'text', 'String', '📅 DAY:', ...
             'Position', [370, 200, 80, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_green, 'HorizontalAlignment', 'left');

    handles.day_status = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                  'String', handles.day_names{handles.current_day}, ...
                                  'Position', [450, 200, 100, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
                                  'BackgroundColor', handles.colors.pastel_yellow, 'ForegroundColor', handles.colors.dark_gray);

    % Status message
    handles.status_message = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                      'String', '✅ Elevator Ready', 'Position', [30, 240, 400, 40], ...
                                      'FontSize', 14, 'FontWeight', 'bold', ...
                                      'BackgroundColor', handles.colors.info_blue, 'ForegroundColor', [0 0 0]);

    % Energy mode display
    uicontrol('Parent', panel_status, 'Style', 'text', 'String', '🔋 ENERGY MODE:', ...
             'Position', [30, 120, 140, 30], 'FontSize', 12, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_green, 'HorizontalAlignment', 'left');

    handles.energy_display = uicontrol('Parent', panel_status, 'Style', 'text', ...
                                      'String', 'NORMAL', 'Position', [180, 120, 120, 30], ...
                                      'FontSize', 14, 'FontWeight', 'bold', ...
                                      'BackgroundColor', handles.colors.safe_green, 'ForegroundColor', [0 0 0]);

    %% Emergency Panel
    handles.emergency_button = uicontrol('Parent', panel_emergency, 'Style', 'pushbutton', ...
                                        'String', '🛑 EMERGENCY STOP', 'Position', [20, 100, 200, 40], ...
                                        'FontSize', 12, 'FontWeight', 'bold', ...
                                        'BackgroundColor', handles.colors.emergency_red, 'ForegroundColor', [1 1 1], ...
                                        'Callback', {@emergency_stop, fig});

    uicontrol('Parent', panel_emergency, 'Style', 'text', 'String', 'EMERGENCY SCENARIOS:', ...
             'Position', [20, 70, 200, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_orange, 'HorizontalAlignment', 'left');

    uicontrol('Parent', panel_emergency, 'Style', 'pushbutton', 'String', '🌋 Earthquake', ...
             'Position', [20, 40, 95, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.earthquake_brown, 'ForegroundColor', [1 1 1], ...
             'Callback', {@simulate_earthquake, fig});

    uicontrol('Parent', panel_emergency, 'Style', 'pushbutton', 'String', '🌊 Flood', ...
             'Position', [125, 40, 95, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.flood_blue, 'ForegroundColor', [1 1 1], ...
             'Callback', {@simulate_flood, fig});

    uicontrol('Parent', panel_emergency, 'Style', 'pushbutton', 'String', '🔥 Fire', ...
             'Position', [20, 10, 95, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.fire_orange, 'ForegroundColor', [1 1 1], ...
             'Callback', {@simulate_fire, fig});

    %% Radio Panel
    handles.radio_button = uicontrol('Parent', panel_radio, 'Style', 'pushbutton', ...
                                    'String', '🔈 RADIO: OFF', 'Position', [20, 60, 200, 30], ...
                                    'FontSize', 11, 'FontWeight', 'bold', ...
                                    'BackgroundColor', handles.colors.light_gray, 'ForegroundColor', handles.colors.dark_gray, ...
                                    'Callback', {@toggle_radio, fig});

    uicontrol('Parent', panel_radio, 'Style', 'text', 'String', 'SELECT SONG:', ...
             'Position', [20, 30, 150, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_pink, 'HorizontalAlignment', 'left');

    handles.song_list = uicontrol('Parent', panel_radio, 'Style', 'popupmenu', ...
                                 'String', handles.radio_songs, 'Position', [20, 5, 200, 25], ...
                                 'FontSize', 9, 'BackgroundColor', [1 1 1], ...
                                 'ForegroundColor', handles.colors.dark_gray, 'Callback', {@change_song, fig});

    %% Day System Panel
    uicontrol('Parent', panel_day_system, 'Style', 'text', 'String', '📅 CURRENT DAY:', ...
             'Position', [20, 100, 120, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_yellow, 'HorizontalAlignment', 'left');

    handles.day_display = uicontrol('Parent', panel_day_system, 'Style', 'text', ...
                                   'String', handles.day_names{handles.current_day}, ...
                                   'Position', [150, 100, 100, 25], 'FontSize', 11, 'FontWeight', 'bold', ...
                                   'BackgroundColor', handles.colors.pastel_green, 'ForegroundColor', handles.colors.dark_gray);

    uicontrol('Parent', panel_day_system, 'Style', 'text', 'String', '📋 SCHEDULE:', ...
             'Position', [20, 70, 120, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_yellow, 'HorizontalAlignment', 'left');

    handles.schedule_status = uicontrol('Parent', panel_day_system, 'Style', 'text', ...
                                       'String', 'Normal Operation', ...
                                       'Position', [150, 70, 100, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
                                       'BackgroundColor', handles.colors.safe_green, 'ForegroundColor', [0 0 0]);

    uicontrol('Parent', panel_day_system, 'Style', 'pushbutton', 'String', '⏭️ Next Day', ...
             'Position', [20, 40, 110, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'ForegroundColor', handles.colors.dark_gray, ...
             'Callback', {@next_day, fig});

    uicontrol('Parent', panel_day_system, 'Style', 'pushbutton', 'String', '📅 Jump to Sunday', ...
             'Position', [140, 40, 110, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_pink, 'ForegroundColor', handles.colors.dark_gray, ...
             'Callback', {@set_sunday, fig});

    uicontrol('Parent', panel_day_system, 'Style', 'text', 'String', '⚡ WEEKEND BOOST:', ...
             'Position', [20, 10, 120, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_yellow, 'HorizontalAlignment', 'left');

    handles.weekend_boost_indicator = uicontrol('Parent', panel_day_system, 'Style', 'text', ...
                                               'String', 'INACTIVE', 'Position', [150, 10, 100, 25], ...
                                               'FontSize', 10, 'FontWeight', 'bold', ...
                                               'BackgroundColor', handles.colors.light_gray, 'ForegroundColor', handles.colors.dark_gray);

    %% Feedback Panel
    uicontrol('Parent', panel_feedback, 'Style', 'text', 'String', '💬 CUSTOMER FEEDBACK:', ...
             'Position', [20, 60, 180, 25], 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.qr_button = uicontrol('Parent', panel_feedback, 'Style', 'pushbutton', ...
                                 'String', '📱 SHOW QR CODE', 'Position', [20, 30, 230, 25], ...
                                 'FontSize', 10, 'FontWeight', 'bold', ...
                                 'BackgroundColor', handles.colors.info_blue, 'ForegroundColor', [1 1 1], ...
                                 'Callback', {@show_qr_code, fig});

    uicontrol('Parent', panel_feedback, 'Style', 'text', 'String', '📊 FEEDBACK STATS:', ...
             'Position', [20, 5, 120, 25], 'FontSize', 9, 'FontWeight', 'bold', ...
             'BackgroundColor', handles.colors.pastel_blue, 'HorizontalAlignment', 'left');

    handles.feedback_stats = uicontrol('Parent', panel_feedback, 'Style', 'text', ...
                                      'String', 'Reviews: 0', 'Position', [150, 5, 100, 25], ...
                                      'FontSize', 9, 'FontWeight', 'bold', ...
                                      'BackgroundColor', [1 1 1], 'ForegroundColor', handles.colors.dark_gray);

    guidata(fig, handles);
    update_request_numbers_display(fig);
    check_day_conditions(fig);
    start_time_timer(fig);
    update_time_display(fig);

    fprintf('✨ Smart Elevator Control System v2.0 Initialized\n');
    fprintf('📅 Day: %s, 🕒 Time: %02d:%02d\n', handles.day_names{handles.current_day}, ...
        handles.current_hour, handles.current_minute);
end

function start_time_timer(fig)
    handles = guidata(fig);
    handles.time_running = true;
    guidata(fig, handles);
    start_background_timer(fig);
end

function start_background_timer(fig)
    try
        while true
            handles = guidata(fig);
            if ~handles.time_running
                break;
            end
            update_system_time([], [], fig);
            pause(1);
        end
    catch
    end
end

function update_system_time(timerObj, event, fig)
    handles = guidata(fig);
    if handles.time_running
        handles.current_minute = handles.current_minute + 5;
        if handles.current_minute >= 60
            handles.current_hour = handles.current_hour + 1;
            handles.current_minute = handles.current_minute - 60;
        end
        if handles.current_hour >= 24
            handles.current_hour = 0;
            next_day([], [], fig);
        end
        update_time_display(fig);
        check_day_conditions(fig);
        guidata(fig, handles);
    end
end

function update_time_display(fig)
    handles = guidata(fig);
    hour_str = sprintf('%02d', handles.current_hour);
    minute_str = sprintf('%02d', handles.current_minute);
    time_str = [hour_str ':' minute_str];
    set(handles.time_display, 'String', time_str);
    if handles.current_hour >= 6 && handles.current_hour < 18
        set(handles.time_display, 'ForegroundColor', [1 1 1]);
    else
        set(handles.time_display, 'ForegroundColor', [1 1 0]);
    end
end

function floor_button_callback(src, event, floor_num, fig)
    handles = guidata(fig);
    if handles.is_sunday
        set_status_message('System closed for Sunday maintenance', fig);
        return;
    end
    if handles.emergency_mode && ~strcmp(handles.active_emergency, 'none')
        set_status_message(sprintf('EMERGENCY ACTIVE (%s)! Cannot accept floor requests', ...
            handles.active_emergency), fig);
        return;
    end
    if handles.emergency_mode
        set_status_message('EMERGENCY! Cannot accept requests', fig);
        return;
    end
    if handles.weight_limit_exceeded
        set_status_message('WEIGHT LIMIT EXCEEDED! Reduce weight to move', fig);
        return;
    end
    if handles.energy_saving_mode
        toggle_energy_saving([], [], fig);
        set_status_message('Energy saving mode deactivated', fig);
    end
    if floor_num == handles.current_floor
        if handles.door_open
            set_status_message(sprintf('Already at floor %d - doors are open', floor_num), fig);
        else
            set_status_message(sprintf('Already at floor %d - opening doors', floor_num), fig);
            open_door([], [], fig);
        end
        return;
    end
    if handles.motion_sensor
        set_status_message('Motion detected - cannot close doors to move', fig);
        return;
    end
    if ~ismember(floor_num, handles.floor_requests)
        handles.floor_requests = [handles.floor_requests, floor_num];
        update_request_numbers_display(fig);
        set_status_message(sprintf('Floor %d requested', floor_num), fig);
        guidata(fig, handles);
    else
        set_status_message(sprintf('Floor %d is already in the request queue', floor_num), fig);
        return;
    end
    if ~handles.is_moving && ~handles.motion_sensor && ~handles.weight_limit_exceeded
        start_elevator_movement(fig);
    end
end

function start_elevator_movement(fig)
    handles = guidata(fig);
    if handles.is_sunday
        return;
    end
    if handles.emergency_mode && strcmp(handles.active_emergency, 'earthquake')
        return;
    end
    if isempty(handles.floor_requests) || handles.is_moving
        return;
    end
    if handles.weight_limit_exceeded
        set_status_message('WEIGHT LIMIT EXCEEDED! Cannot move', fig);
        return;
    end
    if handles.motion_sensor
        return;
    end
    if strcmp(handles.direction, 'STOP')
        if ~isempty(handles.floor_requests)
            [~, idx] = min(abs(handles.floor_requests - handles.current_floor));
            nearest_floor = handles.floor_requests(idx);
            if nearest_floor > handles.current_floor
                handles.direction = 'UP';
            else
                handles.direction = 'DOWN';
            end
        end
    end
    if strcmp(handles.direction, 'UP')
        floors_in_direction = handles.floor_requests(handles.floor_requests > handles.current_floor);
        if ~isempty(floors_in_direction)
            handles.target_floor = min(floors_in_direction);
        else
            handles.direction = 'DOWN';
            floors_in_direction = handles.floor_requests(handles.floor_requests < handles.current_floor);
            if ~isempty(floors_in_direction)
                handles.target_floor = max(floors_in_direction);
            else
                return;
            end
        end
    else
        floors_in_direction = handles.floor_requests(handles.floor_requests < handles.current_floor);
        if ~isempty(floors_in_direction)
            handles.target_floor = max(floors_in_direction);
        else
            handles.direction = 'UP';
            floors_in_direction = handles.floor_requests(handles.floor_requests > handles.current_floor);
            if ~isempty(floors_in_direction)
                handles.target_floor = min(floors_in_direction);
            else
                return;
            end
        end
    end

    handles.is_moving = true;
    handles.move_step = 0;
    handles.total_steps = abs(handles.target_floor - handles.current_floor);
    update_display(handles, fig);

    if strcmp(handles.active_emergency, 'flood')
        set_status_message('EMERGENCY: Moving to 3rd floor for flood safety', fig);
    elseif strcmp(handles.active_emergency, 'fire')
        set_status_message('EMERGENCY: Moving to ground floor for fire evacuation', fig);
    elseif ~strcmp(handles.direction, 'STOP')
        set_status_message(sprintf('Moving %s to floor %d', handles.direction, handles.target_floor), fig);
    end

    guidata(fig, handles);
    if handles.door_open && ~handles.motion_sensor
        handles.door_open = false;
        set(handles.door_indicator, 'String', '🔴 CLOSED', 'BackgroundColor', handles.colors.emergency_red);
        guidata(fig, handles);
        drawnow;
    end
    start_movement_animation(fig);
end

function start_movement_animation(fig)
    handles = guidata(fig);
    if handles.is_sunday
        return;
    end
    if handles.emergency_mode && strcmp(handles.active_emergency, 'earthquake')
        return;
    end
    if ~handles.is_moving || handles.motion_sensor
        return;
    end
    if handles.weight_limit_exceeded
        handles.is_moving = false;
        handles.direction = 'STOP';
        update_display(handles, fig);
        set_status_message('WEIGHT LIMIT EXCEEDED! Movement stopped', fig);
        guidata(fig, handles);
        return;
    end
    move_one_step(fig);
end

function move_one_step(fig)
    handles = guidata(fig);
    if handles.is_sunday
        return;
    end
    if handles.emergency_mode && strcmp(handles.active_emergency, 'earthquake')
        return;
    end
    if ~handles.is_moving || handles.motion_sensor
        return;
    end
    if handles.weight_limit_exceeded
        handles.is_moving = false;
        handles.direction = 'STOP';
        update_display(handles, fig);
        set_status_message('WEIGHT LIMIT EXCEEDED! Movement stopped', fig);
        guidata(fig, handles);
        return;
    end
    handles.move_step = handles.move_step + 1;
    if strcmp(handles.direction, 'UP')
        handles.current_floor = handles.current_floor + 1;
    else
        handles.current_floor = handles.current_floor - 1;
    end
    update_display(handles, fig);
    set_status_message(sprintf('At floor %d...', handles.current_floor), fig);
    guidata(fig, handles);
    drawnow;

    if handles.current_floor == handles.target_floor
        handles.is_moving = false;
        handles.direction = 'STOP';
        idx = find(handles.floor_requests == handles.target_floor, 1);
        if ~isempty(idx)
            handles.floor_requests(idx) = [];
        end
        update_display(handles, fig);
        update_request_numbers_display(fig);

        if strcmp(handles.active_emergency, 'flood') && handles.current_floor == 3
            set_status_message('ARRIVED AT SAFE FLOOR (3rd floor) - Flood emergency protocol active', fig);
            handles.emergency_mode = true;
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        elseif strcmp(handles.active_emergency, 'fire') && handles.current_floor == 0
            set_status_message('ARRIVED AT EVACUATION FLOOR (Ground floor) - Fire emergency protocol active', fig);
            handles.emergency_mode = true;
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        else
            set_status_message(sprintf('Arrived at floor %d', handles.current_floor), fig);
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        end
        guidata(fig, handles);
        drawnow;
        pause(2);
        handles = guidata(fig);
        if ~isempty(handles.floor_requests) && ~handles.motion_sensor && ~handles.weight_limit_exceeded && ~handles.emergency_mode
            start_elevator_movement(fig);
        end
    else
        if (handles.current_hour >= 7 && handles.current_hour < 22)
            base_travel_time = 4;
            time_period = 'Daytime';
        else
            base_travel_time = 6;
            time_period = 'Night';
        end

        if handles.weekend_energy_boost
            travel_time = base_travel_time * 0.5;
            time_period = sprintf('Weekend Boost (%.1fs/floor)', travel_time);
        else
            travel_time = base_travel_time;
            time_period = sprintf('%s (%ds/floor)', time_period, travel_time);
        end

        set_status_message(sprintf('Moving... %s', time_period), fig);
        pause(travel_time);

        handles = guidata(fig);
        if ~handles.weight_limit_exceeded
            move_one_step(fig);
        else
            handles.is_moving = false;
            handles.direction = 'STOP';
            update_display(handles, fig);
            set_status_message('WEIGHT LIMIT EXCEEDED! Movement stopped', fig);
            guidata(fig, handles);
        end
    end
end

function open_door(src, event, fig)
    handles = guidata(fig);
    if handles.is_sunday && strcmp(handles.active_emergency, 'none')
        set_status_message('System closed for Sunday maintenance', fig);
        return;
    end
    if handles.is_moving
        set_status_message('Cannot open doors while elevator is moving', fig);
        return;
    end
    if handles.emergency_mode && ~strcmp(handles.active_emergency, 'none')
        set_status_message(sprintf('EMERGENCY ACTIVE (%s)! Doors cannot be operated', ...
            handles.active_emergency), fig);
        return;
    end
    if handles.emergency_mode
        return;
    end
    if handles.energy_saving_mode
        toggle_energy_saving([], [], fig);
        set_status_message('Energy saving mode deactivated', fig);
    end
    if handles.door_open
        set_status_message('Doors are already open', fig);
        return;
    end
    handles.door_open = true;
    set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
    set_status_message('Doors opening...', fig);
    set(handles.light_indicator, 'String', '🟡 AUTO: ON', 'BackgroundColor', [1 1 0.7]);
    handles.lights_on = true;
    guidata(fig, handles);
end

function close_door(src, event, fig)
    handles = guidata(fig);
    if handles.is_sunday && strcmp(handles.active_emergency, 'none')
        set_status_message('System closed for Sunday maintenance', fig);
        return;
    end
    if handles.is_moving
        set_status_message('Cannot close doors while elevator is moving', fig);
        return;
    end
    if handles.emergency_mode && ~strcmp(handles.active_emergency, 'none')
        set_status_message(sprintf('EMERGENCY ACTIVE (%s)! Doors cannot be operated', ...
            handles.active_emergency), fig);
        return;
    end
    if handles.emergency_mode
        set_status_message('Cannot close doors - Emergency mode active', fig);
        return;
    end
    if handles.weight_limit_exceeded
        set_status_message('Cannot close doors - Weight limit exceeded', fig);
        return;
    end
    if ~handles.door_open
        set_status_message('Doors are already closed', fig);
        return;
    end
    if handles.motion_sensor
        set_status_message('Motion detected - cannot close doors', fig);
        return;
    end
    handles.door_open = false;
    set(handles.door_indicator, 'String', '🔴 CLOSED', 'BackgroundColor', handles.colors.emergency_red);
    set_status_message('Doors closing...', fig);
    guidata(fig, handles);
end

function toggle_motion_sensor(src, event, fig)
    handles = guidata(fig);
    if handles.is_sunday && strcmp(handles.active_emergency, 'none')
        set_status_message('System closed for Sunday maintenance', fig);
        return;
    end
    if handles.emergency_mode && ~strcmp(handles.active_emergency, 'none')
        set_status_message(sprintf('EMERGENCY ACTIVE (%s)! Cannot change sensor', ...
            handles.active_emergency), fig);
        return;
    end
    handles.motion_sensor = ~handles.motion_sensor;
    if handles.motion_sensor
        set(handles.motion_indicator, 'String', '🟢 MOTION DETECTED', 'BackgroundColor', handles.colors.safe_green);
        set_status_message('Motion detected - doors will stay open', fig);
        if ~handles.door_open
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        end
        if handles.is_moving
            handles.is_moving = false;
            handles.direction = 'STOP';
            set_status_message('Motion detected - movement stopped', fig);
            update_display(handles, fig);
        end
    else
        set(handles.motion_indicator, 'String', '🔴 NO MOTION', 'BackgroundColor', handles.colors.emergency_red);
        set_status_message('No motion detected - elevator can move', fig);
        if ~isempty(handles.floor_requests) && ~handles.is_moving && ~handles.emergency_mode && ~handles.weight_limit_exceeded
            start_elevator_movement(fig);
        end
    end
    guidata(fig, handles);
end

function update_weight(src, event, fig)
    handles = guidata(fig);
    handles.weight = round(get(handles.weight_slider, 'Value'));
    set(handles.weight_display, 'String', sprintf('%d / 800 kg', handles.weight));
    if handles.weight > 800
        handles.weight_limit_exceeded = true;
        if handles.is_moving
            handles.is_moving = false;
            handles.direction = 'STOP';
            update_display(handles, fig);
        end
        handles.floor_requests = [];
        update_request_numbers_display(fig);
        if ~handles.door_open
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        end
        set_status_message('WARNING: OVERWEIGHT! Maximum 800 kg - Elevator disabled', fig);
        set(handles.weight_display, 'BackgroundColor', [1 0.8 0.8], 'ForegroundColor', [1 0 0]);
        set(handles.energy_display, 'String', 'OVERWEIGHT', 'BackgroundColor', handles.colors.emergency_red);
    else
        handles.weight_limit_exceeded = false;
        set(handles.weight_display, 'BackgroundColor', [1 1 1], 'ForegroundColor', [0 0 0]);
        if handles.is_moving
            set(handles.energy_display, 'String', 'MOVING', 'BackgroundColor', handles.colors.warning_orange);
        elseif handles.door_open
            set(handles.energy_display, 'String', 'DOORS OPEN', 'BackgroundColor', handles.colors.warning_orange);
        else
            set(handles.energy_display, 'String', 'IDLE', 'BackgroundColor', handles.colors.safe_green);
        end
        if handles.weight > 700
            set_status_message('Warning: Approaching weight limit', fig);
        else
            if ~isempty(handles.floor_requests) && ~handles.is_moving && ~handles.emergency_mode && ~handles.motion_sensor
                start_elevator_movement(fig);
            end
        end
    end
    guidata(fig, handles);
end

function update_volume(src, event, fig)
    handles = guidata(fig);
    handles.audio_volume = get(handles.volume_slider, 'Value') / 100;
    guidata(fig, handles);
end

function emergency_stop(src, event, fig)
    handles = guidata(fig);
    handles.emergency_mode = ~handles.emergency_mode;
    if handles.emergency_mode
        handles.is_moving = false;
        handles.direction = 'STOP';
        set(handles.emergency_button, 'String', '🛑 EMERGENCY ACTIVE', ...
            'BackgroundColor', handles.colors.warning_orange, 'FontSize', 12);
        set_status_message('EMERGENCY STOP ACTIVATED!', fig);
        if ~handles.door_open
            handles.door_open = true;
            set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
        end
        set(handles.light_indicator, 'String', '🟡 AUTO: ON', 'BackgroundColor', [1 1 0.7]);
        handles.lights_on = true;
        handles.floor_requests = [];
        update_request_numbers_display(fig);
    else
        handles.active_emergency = 'none';
        handles.earthquake_magnitude = 0;
        set(handles.emergency_button, 'String', '🛑 EMERGENCY STOP', ...
            'BackgroundColor', handles.colors.emergency_red, 'FontSize', 14);
        set_status_message('Emergency cleared - Normal operation resumed', fig);
        if ~isempty(handles.floor_requests) && ~handles.motion_sensor && ~handles.weight_limit_exceeded
            start_elevator_movement(fig);
        end
    end
    update_display(handles, fig);
    guidata(fig, handles);
end

function toggle_energy_saving(src, event, fig)
    handles = guidata(fig);
    if handles.is_sunday && strcmp(handles.active_emergency, 'none')
        set_status_message('System closed for Sunday maintenance', fig);
        return;
    end
    handles.energy_saving_mode = ~handles.energy_saving_mode;
    if handles.energy_saving_mode
        set(handles.no_passengers_button, 'String', '🔋 PASSENGERS ENTERING', ...
            'BackgroundColor', handles.colors.safe_green, 'ForegroundColor', [0 0 0]);
        if handles.door_open
            handles.door_open = false;
            set(handles.door_indicator, 'String', '🔴 CLOSED', 'BackgroundColor', handles.colors.emergency_red);
        end
        set(handles.light_indicator, 'String', '⚫ AUTO: OFF', 'BackgroundColor', [0.3 0.3 0.3]);
        handles.lights_on = false;
        if handles.radio_playing
            handles.radio_playing = false;
            set(handles.radio_button, 'String', '🔈 RADIO: OFF', 'BackgroundColor', handles.colors.light_gray);
        end
        if handles.is_moving
            handles.is_moving = false;
            handles.direction = 'STOP';
        end
        handles.floor_requests = [];
        update_request_numbers_display(fig);
        set(handles.energy_display, 'String', 'ENERGY SAVING', 'BackgroundColor', [0 0.6 0]);
        set_status_message('Energy saving mode activated - No passengers', fig);
        if handles.motion_sensor
            handles.motion_sensor = false;
            set(handles.motion_indicator, 'String', '🔴 NO MOTION', 'BackgroundColor', handles.colors.emergency_red);
        end
    else
        set(handles.no_passengers_button, 'String', '🔋 NO PASSENGERS MODE', ...
            'BackgroundColor', handles.colors.dark_gray, 'ForegroundColor', [1 1 1]);
        set(handles.light_indicator, 'String', '🟡 AUTO: ON', 'BackgroundColor', [1 1 0.7]);
        handles.lights_on = true;
        set(handles.energy_display, 'String', 'NORMAL', 'BackgroundColor', handles.colors.safe_green);
        set_status_message('Energy saving mode deactivated', fig);
    end
    update_display(handles, fig);
    guidata(fig, handles);
end

function simulate_earthquake(src, event, fig)
    handles = guidata(fig);
    magnitude = 3 + (6 * rand());
    handles.earthquake_magnitude = round(magnitude * 10) / 10;
    handles.emergency_mode = true;
    handles.active_emergency = 'earthquake';
    handles.is_moving = false;
    handles.direction = 'STOP';
    if handles.is_moving
        handles.is_moving = false;
    end
    handles.floor_requests = [];
    update_request_numbers_display(fig);
    if ~handles.door_open
        handles.door_open = true;
        set(handles.door_indicator, 'String', '🟢 OPEN', 'BackgroundColor', handles.colors.safe_green);
    end
    set(handles.emergency_button, 'String', '🌋 EARTHQUAKE ACTIVE', ...
        'BackgroundColor', handles.colors.earthquake_brown, 'FontSize', 12);
    if handles.earthquake_magnitude >= 7.0
        intensity = 'MAJOR';
    elseif handles.earthquake_magnitude >= 5.0
        intensity = 'MODERATE';
    else
        intensity = 'MINOR';
    end
    set_status_message(sprintf('EARTHQUAKE DETECTED! Magnitude: %.1f Richter (%s) - EMERGENCY STOPPED', ...
        handles.earthquake_magnitude, intensity), fig);
    guidata(fig, handles);
    update_display(handles, fig);
end

function simulate_flood(src, event, fig)
    handles = guidata(fig);
    handles.active_emergency = 'flood';
    handles.emergency_mode = false;
    if handles.is_moving
        handles.is_moving = false;
        handles.direction = 'STOP';
    end
    handles.floor_requests = [];
    if handles.current_floor < 3
        set_status_message('FLOOD DETECTED! Emergency protocol: Moving to 3rd floor for safety', fig);
        handles.floor_requests = [3];
        update_request_numbers_display(fig);
        set(handles.emergency_button, 'String', '🌊 FLOOD ACTIVE', ...
            'BackgroundColor', handles.colors.flood_blue, 'FontSize', 12);
        guidata(fig, handles);
        if ~handles.weight_limit_exceeded && ~handles.motion_sensor
            pause(1);
            start_elevator_movement(fig);
        end
    else
        set_status_message('Flood detected - Already on safe floor (3rd floor) - EMERGENCY ACTIVE', fig);
        handles.emergency_mode = true;
        set(handles.emergency_button, 'String', '🌊 FLOOD ACTIVE', ...
            'BackgroundColor', handles.colors.flood_blue, 'FontSize', 12);
        guidata(fig, handles);
    end
end

function simulate_fire(src, event, fig)
    handles = guidata(fig);
    handles.active_emergency = 'fire';
    handles.emergency_mode = false;
    if handles.is_moving
        handles.is_moving = false;
        handles.direction = 'STOP';
    end
    handles.floor_requests = [];
    if handles.current_floor ~= 0
        set_status_message('FIRE DETECTED! Emergency protocol: Moving to ground floor for evacuation', fig);
        handles.floor_requests = [0];
        update_request_numbers_display(fig);
        set(handles.emergency_button, 'String', '🔥 FIRE ACTIVE', ...
            'BackgroundColor', handles.colors.fire_orange, 'FontSize', 12);
        guidata(fig, handles);
        if ~handles.weight_limit_exceeded && ~handles.motion_sensor
            pause(1);
            start_elevator_movement(fig);
        end
    else
        set_status_message('Fire detected - Already at ground floor - EMERGENCY ACTIVE', fig);
        handles.emergency_mode = true;
        set(handles.emergency_button, 'String', '🔥 FIRE ACTIVE', ...
            'BackgroundColor', handles.colors.fire_orange, 'FontSize', 12);
        guidata(fig, handles);
    end
end

function toggle_radio(src, event, fig)
    handles = guidata(fig);
    handles.radio_playing = ~handles.radio_playing;
    if handles.radio_playing
        set(handles.radio_button, 'String', '🔊 RADIO: ON', 'BackgroundColor', handles.colors.safe_green);
        set_status_message('Radio playing', fig);
        try
            beep();
        catch
            fprintf('Radio sound played\n');
        end
    else
        set(handles.radio_button, 'String', '🔈 RADIO: OFF', 'BackgroundColor', handles.colors.light_gray);
    end
    guidata(fig, handles);
end

function change_song(src, event, fig)
    handles = guidata(fig);
    handles.current_song = get(handles.song_list, 'Value');
    if handles.radio_playing
        set_status_message(sprintf('Changed to: %s', handles.radio_songs{handles.current_song}), fig);
    end
    guidata(fig, handles);
end

function check_day_conditions(fig)
    handles = guidata(fig);
    if handles.current_day == 7  % Sunday
        handles.is_sunday = true;
        handles.system_disabled = true;
        set(handles.schedule_status, 'String', 'SUNDAY - CLOSED', ...
            'BackgroundColor', handles.colors.emergency_red);
        set_status_message('SYSTEM CLOSED - Sunday maintenance day', fig);
        disable_system_controls(fig, true);
    else
        handles.is_sunday = false;
        handles.system_disabled = false;
        set(handles.schedule_status, 'String', 'Normal Operation', ...
            'BackgroundColor', handles.colors.safe_green);
        disable_system_controls(fig, false);
        if (handles.current_day == 5 || handles.current_day == 6) && ...  % Friday or Saturday
           handles.current_hour >= 12 && handles.current_hour < 20  % Afternoon hours
            handles.weekend_energy_boost = true;
            set(handles.weekend_boost_indicator, 'String', '🟢 ACTIVE', ...
                'BackgroundColor', handles.colors.safe_green);
            set_status_message('Weekend energy boost active - Faster elevator movement', fig);
        else
            handles.weekend_energy_boost = false;
            set(handles.weekend_boost_indicator, 'String', '⚫ INACTIVE', ...
                'BackgroundColor', handles.colors.light_gray);
        end
    end
    set(handles.day_display, 'String', handles.day_names{handles.current_day});
    set(handles.day_status, 'String', handles.day_names{handles.current_day});
    guidata(fig, handles);
end

function next_day(src, event, fig)
    handles = guidata(fig);
    handles.current_day = mod(handles.current_day, 7) + 1;
    handles.current_hour = 7;
    handles.current_minute = 0;
    guidata(fig, handles);
    update_time_display(fig);
    check_day_conditions(fig);
    fprintf('Day advanced to: %s\n', handles.day_names{handles.current_day});
end

function set_sunday(src, event, fig)
    handles = guidata(fig);
    handles.current_day = 7;
    guidata(fig, handles);
    check_day_conditions(fig);
    fprintf('Set to: Sunday (Maintenance Day)\n');
end

function disable_system_controls(fig, disabled)
    handles = guidata(fig);
    if disabled
        set_status_message('SYSTEM DISABLED - Sunday maintenance day. Emergency only.', fig);
        set(handles.energy_display, 'String', 'MAINTENANCE', ...
            'BackgroundColor', [0.5 0.5 0.5]);
    else
        set_status_message('System operational', fig);
    end
end

function show_qr_code(src, event, fig)
    handles = guidata(fig);
    qr_fig = figure('Name', 'Feedback QR Code', 'NumberTitle', 'off', ...
                   'Position', [500, 300, 400, 500], 'MenuBar', 'none', ...
                   'Color', [0.96 0.96 0.96]);
    uicontrol('Parent', qr_fig, 'Style', 'text', 'String', '💬 CUSTOMER FEEDBACK PORTAL', ...
             'Position', [50, 450, 300, 30], 'FontSize', 16, 'FontWeight', 'bold', ...
             'BackgroundColor', [0.96 0.96 0.96]);
    uicontrol('Parent', qr_fig, 'Style', 'text', 'String', 'Scan QR code to submit feedback:', ...
             'Position', [50, 420, 300, 25], 'FontSize', 12, ...
             'BackgroundColor', [0.96 0.96 0.96]);
    axes('Parent', qr_fig, 'Position', [0.1, 0.25, 0.8, 0.3]);
    qr_text = sprintf(['┌─────────────────────────────┐\n' ...
                       '│ ▄▄▄▄▄ ▄▄ ▄▄▄▄▄ ▄▄ ▄▄▄▄▄   │\n' ...
                       '│ █   █ ██ █   █ ██ █   █   │\n' ...
                       '│ █▄▄▄█ ██ █▄▄▄█ ██ █▄▄▄█   │\n' ...
                       '│ ▄▄▄▄▄▄▄█ ▄▄▄▄▄▄▄█ ▄▄▄▄▄   │\n' ...
                       '│ █▄▄▄▄█ ▄ █▄▄▄▄█ ▄ █   █   │\n' ...
                       '│ ▄▄▄▄▄ ██ ▄▄▄▄▄ ██ █▄▄▄█   │\n' ...
                       '│ █   █ ██ █   █ ██ ▄▄▄▄▄   │\n' ...
                       '│ █▄▄▄█ ▄▄ █▄▄▄█ ▄▄ █   █   │\n' ...
                       '└─────────────────────────────┘']);
    text(0.5, 0.5, qr_text, 'HorizontalAlignment', 'center', ...
         'FontName', 'Courier', 'FontSize', 8);
    axis off;
    uicontrol('Parent', qr_fig, 'Style', 'text', 'String', 'Or visit:', ...
             'Position', [50, 150, 80, 25], 'BackgroundColor', [0.96 0.96 0.96]);
    url_text = uicontrol('Parent', qr_fig, 'Style', 'edit', 'String', handles.feedback_url, ...
                        'Position', [50, 120, 300, 25], 'BackgroundColor', [1 1 1]);
    uicontrol('Parent', qr_fig, 'Style', 'text', 'String', 'Quick Feedback:', ...
             'Position', [50, 90, 300, 25], 'FontWeight', 'bold', ...
             'BackgroundColor', [0.96 0.96 0.96]);
    uicontrol('Parent', qr_fig, 'Style', 'pushbutton', 'String', '⚠️ Report Issue', ...
             'Position', [50, 60, 90, 25], 'BackgroundColor', handles.colors.pastel_pink, ...
             'Callback', {@submit_feedback, 'complaint', fig});
    uicontrol('Parent', qr_fig, 'Style', 'pushbutton', 'String', '⭐ Give Compliment', ...
             'Position', [150, 60, 90, 25], 'BackgroundColor', handles.colors.pastel_green, ...
             'Callback', {@submit_feedback, 'compliment', fig});
    uicontrol('Parent', qr_fig, 'Style', 'pushbutton', 'String', '🎵 Song Request', ...
             'Position', [250, 60, 90, 25], 'BackgroundColor', handles.colors.pastel_blue, ...
             'Callback', {@submit_feedback, 'song_request', fig});
    uicontrol('Parent', qr_fig, 'Style', 'pushbutton', 'String', 'Close', ...
             'Position', [150, 20, 100, 30], 'BackgroundColor', handles.colors.light_gray, ...
             'Callback', 'close(gcf)');
end

function submit_feedback(src, event, feedback_type, fig)
    handles = guidata(fig);
    handles.feedback_count = handles.feedback_count + 1;
    switch feedback_type
        case 'complaint'
            handles.customer_complaints = handles.customer_complaints + 1;
            message = sprintf('Issue reported! Total complaints: %d', handles.customer_complaints);
            color = [1 0.9 0.9];
        case 'compliment'
            handles.customer_compliments = handles.customer_compliments + 1;
            message = sprintf('Thank you for the compliment! Total: %d', handles.customer_compliments);
            color = [0.9 1 0.9];
        case 'song_request'
            requested_songs = {'Jazz Piano', 'Classical Violin', 'Pop Rock', 'Chillout', 'Disco'};
            new_request = requested_songs{randi(length(requested_songs))};
            handles.song_requests{end+1} = new_request;
            message = sprintf('Song requested: %s', new_request);
            color = [0.9 0.9 1];
    end
    stats_text = sprintf('📊 Reviews: %d | ⭐: %d | ⚠️: %d', ...
        handles.feedback_count, handles.customer_compliments, handles.customer_complaints);
    set(handles.feedback_stats, 'String', stats_text);
    set_status_message(message, fig);
    guidata(fig, handles);
    msgbox(message, 'Feedback Submitted', 'custom', color);
    process_feedback_actions(fig);
end

function process_feedback_actions(fig)
    handles = guidata(fig);
    if handles.customer_complaints >= 3
        suggestion_fig = figure('Name', 'Feedback Analysis', 'NumberTitle', 'off', ...
                               'Position', [600, 400, 400, 200], ...
                               'Color', [0.96 0.96 0.96]);
        uicontrol('Parent', suggestion_fig, 'Style', 'text', ...
                 'String', '⚠️ MAINTENANCE RECOMMENDED', ...
                 'Position', [50, 150, 300, 30], 'FontSize', 14, 'FontWeight', 'bold', ...
                 'ForegroundColor', handles.colors.emergency_red, ...
                 'BackgroundColor', [0.96 0.96 0.96]);
        uicontrol('Parent', suggestion_fig, 'Style', 'text', ...
                 'String', sprintf('Multiple issues reported (%d complaints).', handles.customer_complaints), ...
                 'Position', [50, 120, 300, 25], ...
                 'BackgroundColor', [0.96 0.96 0.96]);
        uicontrol('Parent', suggestion_fig, 'Style', 'text', ...
                 'String', 'Consider scheduling maintenance on Sunday.', ...
                 'Position', [50, 90, 300, 25], ...
                 'BackgroundColor', [0.96 0.96 0.96]);
        uicontrol('Parent', suggestion_fig, 'Style', 'pushbutton', 'String', 'OK', ...
                 'Position', [150, 40, 100, 30], 'BackgroundColor', handles.colors.pastel_blue, ...
                 'Callback', 'close(gcf)');
    end
end

function update_display(handles, fig)
    set(handles.floor_display, 'String', sprintf('Floor %d', handles.current_floor));
    set(handles.target_display, 'String', sprintf('Floor %d', handles.target_floor));
    if strcmp(handles.direction, 'UP')
        set(handles.direction_indicator, 'String', '⬆', 'ForegroundColor', handles.colors.emergency_red, 'FontSize', 24);
    elseif strcmp(handles.direction, 'DOWN')
        set(handles.direction_indicator, 'String', '⬇', 'ForegroundColor', handles.colors.info_blue, 'FontSize', 24);
    else
        set(handles.direction_indicator, 'String', '●', 'ForegroundColor', handles.colors.dark_gray, 'FontSize', 20);
    end
    if handles.weight_limit_exceeded
        set(handles.energy_display, 'String', 'OVERWEIGHT', 'BackgroundColor', handles.colors.emergency_red);
    elseif handles.is_moving
        set(handles.energy_display, 'String', 'MOVING', 'BackgroundColor', handles.colors.warning_orange);
    elseif handles.door_open
        set(handles.energy_display, 'String', 'DOORS OPEN', 'BackgroundColor', handles.colors.warning_orange);
    else
        if handles.energy_saving_mode
            set(handles.energy_display, 'String', 'ENERGY SAVING', 'BackgroundColor', [0 0.6 0]);
        else
            set(handles.energy_display, 'String', 'IDLE', 'BackgroundColor', handles.colors.safe_green);
        end
    end
end

function update_request_numbers_display(fig)
    handles = guidata(fig);
    if isempty(handles.floor_requests)
        set(handles.request_numbers_display, 'String', 'None');
    else
        request_str = '';
        for i = 1:length(handles.floor_requests)
            if i > 1
                request_str = sprintf('%s, %d', request_str, handles.floor_requests(i));
            else
                request_str = sprintf('%d', handles.floor_requests(i));
            end
        end
        set(handles.request_numbers_display, 'String', request_str);
    end
end

function set_status_message(message, fig)
    handles = guidata(fig);
    set(handles.status_message, 'String', message);
    if ~handles.energy_saving_mode && ~handles.is_moving && ~handles.door_open && handles.lights_on
        set(handles.light_indicator, 'String', '⚫ AUTO: OFF', 'BackgroundColor', [0.5 0.5 0.5]);
        handles.lights_on = false;
    elseif ~handles.energy_saving_mode && (~handles.lights_on && (handles.is_moving || handles.door_open))
        set(handles.light_indicator, 'String', '🟡 AUTO: ON', 'BackgroundColor', [1 1 0.7]);
        handles.lights_on = true;
    end
    fprintf('Status: %s\n', message);
    guidata(fig, handles);
end


