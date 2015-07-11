function out = action(varargin)
%ML.Config.action MLab configuration action
%
%   See also ML.config

% --- Inputs
in = ML.Input;
in.action = @ischar;
in.value{''} = @(x) ischar(x) || islogical(x);
in = +in;

% --- Prepare output
out = '';

% --- Split action

Act = strsplit(in.action, ',');
for i = 1:numel(Act)
    
    cfile = 'MLab';
    loc = '';
    tmp = strsplit(Act{i}, '|');
    if numel(tmp)>1
        loc = ['|' tmp{2}];
        cfile = [cfile '.' tmp{2}];
    end
    tmp = tmp{1};
    A = strsplit(tmp, ':');
    
    switch A{1}
            
        case 'get'
            
            tmp = load([prefdir filesep cfile '.mat']);
            out = tmp.config;
            for i = 2:numel(A)
                out = out.(A{i});
            end
            
        case 'set'
            
            fname = [prefdir filesep cfile '.mat'];
            tmp = load(fname);
            s = 'tmp.config';
            for i = 2:numel(A)
                s = [s '.' A{i}];
            end
            
            if isstruct(eval(s)), s = [s '.value']; end
            
            switch class(in.value)
                case 'char'
                    s = [s '=''' in.value ''';'];
                otherwise
                    s = [s '=' num2str(in.value) ';'];
            end
            eval(s);
            save(fname, '-struct', 'tmp');
            
        case 'menu'
            ML.config(A{2});
        
        case 'input'
            fprintf('\nPlease ente the new value for %s [Enter to skip]:\n', strjoin(A(2:end), '.'));
            a = input('?> ', 's');
            if ~isempty(a)
                ML.Config.action(['set:' strjoin(A(2:end),':')], a);
            end
            
        case 'toggle'
            b = ML.Config.action(['get:' strjoin(A(2:end),':') loc]);
            
            if isstruct(b)
                ML.Config.action(['set:' strjoin(A(2:end),':') loc], ~b.value);
            else
                ML.Config.action(['set:' strjoin(A(2:end),':') loc], ~b);
            end
            
            % Shortcuts
            if strcmp(A{2}, 'shortcut')
            
                id = A{3};
                config = load([prefdir filesep 'MLab.mat']);
                tmp = load([prefdir filesep cfile '.mat']);
                tag = tmp.config.shortcut.(id).desc;
                code = tmp.config.shortcut.(id).code;
                icon = tmp.config.shortcut.(id).icon;
                
                S = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;
                if ~tmp.config.shortcut.(id).value || ismember(tag, arrayfun(@char, S.getShortcutsByCategory('MLab').toArray, 'UniformOutput', false))
                    S.removeShortcut('MLab', tag);
                else
                    S.addShortcutToBottom(tag, code, [config.config.path icon], 'MLab', 'true');
                end
                
            end
            
        case 'quit'
            % Do nothing
    end
    
end