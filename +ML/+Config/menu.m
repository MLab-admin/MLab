function out = menu(varargin)
%ML.Config.menu configuration menus
%
%   See also ML.config

% --- Inputs
in = ML.Input;
in.menu = @ischar;
in = +in;

% --- Menus list

% Preparation
out = struct('clear', true, 'title', '', 'text', '', ...
    'opt', struct('text', {}, 'cmd', {}, 'action', {}));

switch in.menu
    
    % --- Main ------------------------------------------------------------
    case 'main'

        out.title = '~b{MLab configuration}';
        out.text = 'Please choose a menu:';
        
        new_opt;
        out.opt(end).value = 'Matlab startup';
        out.opt(end).desc = '';
        out.opt(end).cmd = 'a';
        out.opt(end).action = 'menu:startup';
        
        new_opt;
        out.opt(end).value = 'MLab start';
        out.opt(end).desc = '';
        out.opt(end).cmd = 's';
        out.opt(end).action = 'menu:start';
        
        if ML.isdesktop
            new_opt;
            out.opt(end).value = 'Shortcuts';
            out.opt(end).desc = '';
            out.opt(end).cmd = 'c';
            out.opt(end).action = 'menu:shortcuts';
        else
            new_opt;
            out.opt(end).value = 'Shortcuts [not available in command line mode]';
            out.opt(end).desc = '';
            out.opt(end).cmd = ' ';
            out.opt(end).action = 'menu:main';
        end
        
        new_opt;
        out.opt(end).value = 'User';
        out.opt(end).desc = '';
        out.opt(end).cmd = 'u';
        out.opt(end).action = 'menu:user';
       
    case 'startup'
        
        out.title = '~b{MLab startup configuration}';
        out.text = 'These settings control what MLab does upon Matlab''s startup.';
        
        new_opt;
        out.opt(end).value = bool2str('get:startup:autostart');
        out.opt(end).desc = 'Autostart';
        out.opt(end).cmd = 'a';
        out.opt(end).action = 'toggle:startup:autostart,menu:startup';
        
        new_opt;
        out.opt(end).value = bool2str('get:startup:update');
        out.opt(end).desc = 'Check for updates';
        out.opt(end).cmd = 'u';
        out.opt(end).action = 'toggle:startup:update,menu:startup';
        
        new_opt;
        out.opt(end).value = bool2str('get:startup:disp_message');
        out.opt(end).desc = 'Dislay welcome message';
        out.opt(end).cmd = 'd';
        out.opt(end).action = 'toggle:startup:disp_message,menu:startup';
        
        new_opt;
        out.opt(end).value = ML.Config.action('get:startup:message');
        out.opt(end).desc = 'Welcome message';
        out.opt(end).cmd = 'm';
        out.opt(end).action = 'input:startup:message,menu:startup';
    
    case 'start'
        
        out.title = '~b{MLab start configuration}';
        out.text = 'These settings control what MLab does upon start.';
        
        new_opt;
        out.opt(end).value = bool2str('get:start:update');
        out.opt(end).desc = 'Check for updates';
        out.opt(end).cmd = 'u';
        out.opt(end).action = 'toggle:start:update,menu:start';
    
    case 'shortcuts'
        
        out.title = '~b{MLab shortcut configuration}';
        out.text = 'These settings control the visible MLab shortcuts.';
        
        new_opt;
        out.opt(end).value = bool2str('get:shortcut:start');
        out.opt(end).desc = 'MLab start';
        out.opt(end).cmd = 's';
        out.opt(end).action = 'toggle:shortcut:start,menu:shortcuts';
    
        new_opt;
        out.opt(end).value = bool2str('get:shortcut:stop');
        out.opt(end).desc = 'MLab stop';
        out.opt(end).cmd = 'p';
        out.opt(end).action = 'toggle:shortcut:stop,menu:shortcuts';
        
        new_opt;
        out.opt(end).value = bool2str('get:shortcut:state');
        out.opt(end).desc = 'MLab state';
        out.opt(end).cmd = 't';
        out.opt(end).action = 'toggle:shortcut:state,menu:shortcuts';
        
        new_opt;
        out.opt(end).value = bool2str('get:shortcut:config');
        out.opt(end).desc = 'MLab config';
        out.opt(end).cmd = 'c';
        out.opt(end).action = 'toggle:shortcut:config,menu:shortcuts';
    
        new_opt;
        out.opt(end).value = bool2str('get:shortcut:update');
        out.opt(end).desc = 'MLab update';
        out.opt(end).cmd = 'u';
        out.opt(end).action = 'toggle:shortcut:update,menu:shortcuts';
        
    case 'user'
        
        out.title = '~b{MLab user configuration}';
        out.text = 'These settings are used for default custom message, and are required for version control.';
        
        new_opt;
        out.opt(end).value = ML.Config.action('get:user:name');
        out.opt(end).desc = 'User name';
        out.opt(end).cmd = 'n';
        out.opt(end).action = 'input:user:name,menu:user';
        
        new_opt;
        out.opt(end).value = ML.Config.action('get:user:email');
        out.opt(end).desc = 'User email';
        out.opt(end).cmd = 'e';
        out.opt(end).action = 'input:user:email,menu:user';
        
    otherwise
        out = NaN;
end

    % === Nested functions ================================================
    
    function new_opt
        out.opt(end+1).text = '';
    end

    function out = bool2str(b)
        
        res = ML.Config.action(b);
        if isstruct(res)
            res = res.value;
        end
        
        if res
            out = 'Yes';
        else
            out = 'No';
        end
    end

end