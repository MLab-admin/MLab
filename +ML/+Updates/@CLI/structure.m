function structure(this)
% ML.Updates.CLI/structure MLab update CLI structure
%   ML.Updates.CLI/structure() prepares the CLI structure.
%
%   See also ML.Updates.CLI

F = fieldnames(this.list);

k = 1;
for i = 1:numel(F)
    
    this.text(k,1, F{i});
    
    C = this.list.(F{i});
    
    
    if this.isfirst
        switch numel(C)
            
            case 0
                this.text(k,2, '-');
                
            case 1
                this.select(k,2, sprintf('%i update', numel(C)), 'symbols', {'?', '.'});
                
            otherwise
                this.select(k,2, sprintf('%i updates', numel(C)), 'symbols', {'?', '.'});
                
        end
    elseif isstruct(this.elms{k,2}) && strcmp(this.elms{k,2}.type, 'select') && this.elms{k,2}.values==1
        
        k = k+1;
        this.text(k,1, '');
        this.text(k,2, 'test');
        
    end
    
    k = k+1;
end

% C.input(1, 1, 'ok', 'value', 3);
%
% C.select(1, 2, 'Hello');
% C.select(1, 3, 1:5, 'symbols', {'No' 'Yes'});
% C.select(1, 4, {'World' 'Dolly' 'Kitty'}, 'mode', 'multi', 'desc', 'test');
%
% C.action(2, 1, 'Test', @test_action);
% C.text(2, 2,'ok');

% this.elms{2,2}.values

