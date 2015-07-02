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

        out.title = '~b{MLab Configuration}';
        out.text = 'Please choose a menu:';
        
        new_opt;
        out.opt(end).value = 'Startup';
        out.opt(end).desc = '';
        out.opt(end).cmd = 's';
        out.opt(end).action = 'menu:startup';
        
        new_opt;
        out.opt(end).value = 'User';
        out.opt(end).desc = '';
        out.opt(end).cmd = 'u';
        out.opt(end).action = 'menu:user';
       
    case 'startup'
        
        out.title = '~b{MLab Startup Configuration}';
        out.text = 'These settings control what MLab does upon Matlab''s startup.';
        
        new_opt;
        out.opt(end).value = bool2str('get:startup:autostart');
        out.opt(end).desc = 'Autostart';
        out.opt(end).cmd = 'a';
        out.opt(end).action = 'toggle:startup:autostart,menu:startup';
        
        
    case 'user'
        
        out.title = '~b{MLab User Configuration}';
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
        if ML.Config.action(b)
            out = 'Yes';
        else
            out = 'No';
        end
    end

end