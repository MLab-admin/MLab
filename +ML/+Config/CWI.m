function CWI(varargin)
%ML.Config.CWI Configuration command-window interface
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

% --- Display options
fprintf('\n');
for i = 1:numel(M.opt)
    ML.CW.print('\t<a href="matlab:ML.Config.action(''%s'');">%s</a> %s\n', ...
        M.opt(i).action, M.opt(i).value, M.opt(i).desc);
end
fprintf('\n');