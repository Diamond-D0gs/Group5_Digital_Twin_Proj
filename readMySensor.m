function current_temp = readMySensor()
% This helper function handles all serial communication in a non-blocking way.
% It is called by the MATLAB Function block in Simulink.

    % Persistent variables to hold the serial object and the last known temperature
    persistent device;
    persistent last_temp;
    
    % Initialize the serial device and last_temp on the very first run
    if isempty(device)
        device = serialport("COM21", 115200);
        configureTerminator(device, "LF");
        last_temp = 75.0; % Default starting temp
    end
    
    % Check if any new data is available on the serial port
    if device.NumBytesAvailable > 0
        % If data is available, read the new line
        data_str = readline(device);
        temp_val = str2double(data_str);
        
        % If the new data is a valid number, update our stored temperature
        if ~isnan(temp_val)
            last_temp = temp_val;
        end
    end
    
    % ALWAYS return the last known temperature
    current_temp = last_temp;
end