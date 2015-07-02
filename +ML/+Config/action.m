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
    
    A = strsplit(Act{i}, ':');
    
    switch A{1}
            
        case 'get'
            
            tmp = load([prefdir filesep 'MLab.mat']);
            out = tmp.config;
            for i = 2:numel(A)
                out = out.(A{i});
            end
            
        case 'set'
            
            fname = [prefdir filesep 'MLab.mat'];
            tmp = load(fname);
            s = 'tmp.config';
            for i = 2:numel(A)
                s = [s '.' A{i}];
            end
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
            b = ML.Config.action(['get:' strjoin(A(2:end),':')]);
            ML.Config.action(['set:' strjoin(A(2:end),':')], ~b);
            
        case 'quit'
            % Do nothing
    end
    
end