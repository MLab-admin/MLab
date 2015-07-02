function CLI(varargin)
%ML.Config.CLI Configuration command-line interface
%
%   See also ML.config

% --- Inputs
in = ML.Input;
in.menu = @ischar;
in = +in;

% --- Get the menu
M = ML.Config.menu(in.menu);

% --- Clear command line ?
if M.clear
    clc
else
    fprintf('\n');
end

% --- Display title
if ~isempty(M.title)
    ML.CW.line(M.title);
    fprintf('\n');
end

% --- Display menu description
if ~isempty(M.text)
    ML.CW.print(M.text);
    fprintf('\n');
end

% -- Add the home option
if ~strcmp(in.menu, 'main')
    M.opt(end+1).value = 'Back to main menu';
    M.opt(end).desc = '';
    M.opt(end).cmd = 'h';
    M.opt(end).action = 'menu:main';
end

% -- Add the quit option
M.opt(end+1).value = 'Quit';
M.opt(end).desc = '';
M.opt(end).cmd = 'q';
M.opt(end).action = 'quit';

% --- Display options
fprintf('\n');
for i = 1:numel(M.opt)
    
    if isempty(M.opt(i).desc)
        ML.CW.print('\t[\033[1;33;40m%s\033[0m] %s\n', M.opt(i).cmd, M.opt(i).value);
    else
        ML.CW.print('\t[\033[1;33;40m%s\033[0m] [%s] %s\n', M.opt(i).cmd, ...
            M.opt(i).value, M.opt(i).desc);
    end
end
fprintf('\n\033[s');

while true
    
    % --- Get input
    fprintf('\033[u\033[K');
    a = input('?> ', 's');
    
    % --- Trigger action
    I = find(strcmp(a, {M.opt(:).cmd}));
    if ~isempty(I)
        ML.Config.action(M.opt(I).action);
        break;
    end
    
end
