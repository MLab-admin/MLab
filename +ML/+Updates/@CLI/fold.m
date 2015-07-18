function out = fold(this, varargin)
% ML.Updates.CLI/fold CLI folding/unfolding method
%   ML.Updates.CLI/fold('all') folds all elements of the CLI.
%
%   ML.Updates.CLI/fold('none') unfolds all elements of the CLI.
%
%   See also ML.Updates.CLI

% --- Inputs
in = ML.Input;
in.what = @ischar;
in = +in;

switch in.what
    
    case 'all'
        for i = 1:size(this.elms,1)
            if isstruct(this.elms{i,2}) && strcmp(this.elms{i,2}.type, 'select')
                this.elms{i,2}.values = 0;
            end
        end
        
    case 'none'
        for i = 1:size(this.elms,1)
            if isstruct(this.elms{i,2}) && strcmp(this.elms{i,2}.type, 'select')
                this.elms{i,2}.values = 1;
            end
        end
        
end

% --- Output
out = true;