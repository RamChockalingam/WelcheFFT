% Assuming we have an audio file named 'your_audio_file.wav'

% Load the audio file
[y, Fs] = audioread('your_audio_file.wav');

% Extract pitch using the pitch function from Audio Toolbox
p = pitch(y, Fs);

% Set threshold values for pitch to represent different emotions
frustration_threshold = 200; 
sadness_threshold = 300; 

% Initialize LEDs )
redLED = 17;    %red LED
greenLED = 18;  % green LED
blueLED = 19;   % blue LED


% FFT parameters
window_size = 1024;
overlap_ratio = 0.75;

% Calculate the FFT for each segment using a sliding window
[~, f, t, pxx] = spectrogram(audio_signal, hamming(window_size), round(overlap_ratio * window_size), window_size, fs);

% Thresholds for LED control
frustration_threshold = 1e-3; % Adjust as needed
sadness_threshold = 1e-2; % Adjust as needed
% a figure for plotting the pitch over time
figure;

% Process the pitch values and control the LEDs
for i = 1:length(p)
    % Plot pitch over time
    subplot(2,1,1);
    plot(p(1:i));
    title('Pitch Over Time');
    xlabel('Sample');
    ylabel('Pitch (Hz)');
    
     % Extract the spectrum for the current time frame
    spectrum = pxx(:, i);
    
    % Check for emotions based on spectral content
    if max(spectrum) > frustration_threshold
        % Blink red LED for frustrating moments
        blinkLED(redLED);
    elseif max(spectrum) > sadness_threshold
        % Blink green LED for sad moments
        blinkLED(greenLED);
    else
        % Blink blue LED for happy moments
        blinkLED(blueLED);
    end
    
       % Pause for a short duration to simulate real-time processing
    pause(0.1);
end

% Plot spectrogram
    subplot(2,1,1);
    imagesc(t, f, 10*log10(pxx));
    axis xy;
    title('Spectrogram');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

% Function to blink an LED
function blinkLED(ledPin)
    % Create Arduino object
a = arduino('COM3', 'Uno'); 

% Blink the LED
for i = 1:5 % Blink 5 times
    blinkled(a, ledPin);
    pause(1); % Adjust the pause duration based on your preference
end

% Clear Arduino object
clear a;

% Function to blink an LED
function blinkled(a, pin)
    writeDigitalPin(a, pin, 1); % Turn the LED on
    pause(0.5);                  % Keep the LED on for 0.5 seconds
    writeDigitalPin(a, pin, 0); % Turn the LED off
    pause(0.5);                  % Keep the LED off for 0.5 seconds
end

end



