function structure(this)
% ML.Updates.CLI/structure MLab update CLI structure
%   ML.Updates.CLI/structure() prepares the CLI structure.
%
%   See also ML.Updates.CLI

% --- Parameters ----------------------------------------------------------

utext = [char(8594) ' update'];

% -------------------------------------------------------------------------

F = fieldnames(this.list);

if this.isfirst
    
    for i = 1:numel(F)
        
        % --- Text
        this.text(i,1, F{i});
        
        % --- Select
        C = this.list.(F{i});
        switch numel(C)
            
            case 0
                this.text(i,2, '-');
                
            case 1
                this.select(i,2, sprintf('~b{%i update}', numel(C)), 'symbols', {'?', '.'});
                this.action(i,3, utext, @update, 'args', F(i));
                
            otherwise
                this.select(i,2, sprintf('~b{%i updates}', numel(C)), 'symbols', {'?', '.'});
                this.action(i,3, utext, @update, 'args', F(i));
                
        end
        
    end
    
else
    
    % --- Get elements
    E = struct();
    for i = 1:size(this.elms,1)
        if ~strcmp(this.elms{i,1}.type, 'text'), break; end
            
        if ~isempty(this.elms{i,1}.text)
            E.(this.elms{i,1}.text) = this.elms{i,2};    
        end
    end
    
    % Purge elements
    this.elms = {};
    
    % --- Define structure
    k = 1;
    for i = 1:numel(F)
        
        % --- Text
        this.text(k,1, F{i});
                
        % --- Select
        C = this.list.(F{i});
        switch numel(C)
                
            case 0
                this.text(k,2, '-');
                
            case 1
                this.select(k,2, sprintf('~b{%i update}', numel(C)), 'symbols', {'?', '.'}, 'values', E.(F{i}).values);
                this.action(k,3, utext, @update, 'args', F(i));
                
            otherwise
                this.select(k,2, sprintf('~b{%i updates}', numel(C)), 'symbols', {'?', '.'}, 'values', E.(F{i}).values);
                this.action(k,3, utext, @update, 'args', F(i));
        end
        
        % --- Unfolding
        if strcmp(E.(F{i}).type, 'select') && E.(F{i}).values
            
            k = k+1;
            this.text(k,1, '');
            for j = 1:numel(C)
                tmp = regexp(C{j}, '([^ ]*) (.*)', 'tokens');
                C{j} = [' ~c[orange]{' tmp{1}{1} '} ' tmp{1}{2}];
            end
            if i<numel(F), C = [C {''}]; end
            this.text(k,2, C);
            
        end
          
        k = k+1;
        
    end
   
end

% --- Footer --------------------------------------------------------------

k = size(this.elms,1)+1;

this.action(k,1, 'Update all', @update, 'args', {'all'});

this.action(k+1,1, 'Unfold all', @fold, 'args', {'none'});
this.action(k+1,2, 'Fold all', @fold, 'args', {'all'});
