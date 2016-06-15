function display(this, varargin)

% --- Inputs --------------------------------------------------------------

in = ML.Input;
in.numCols(4) = @isnumeric;
in = +in;

% -------------------------------------------------------------------------

% --- Header
% ML.CW.print(' ~bc[50 100 150]{%s} (Package - <a href="">Open folder</a>)\n', this.Name);
ML.CW.print(' ~bc[50 100 150]{%s} (Package)\n', this.Name);
ML.CW.print('~c[100 175 175]{%s}\n', this.Fullpath);

% --- Properties

Prop = cell(1,2);

Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Package
if isprop(this, 'Package')
    Prop{end+1,1} = '~c[gray]{Package}';
    Prop{end,2} = ['<a href="matlab:ML.search(''' this.Package ''', ''verbose'', false);">' this.Package '</a>\n'];
end

ML.Text.table(Prop, 'style', 'compact', 'border', 'none');

% Content

ML.CW.print('~bc[gray]{Content}');
if isempty(this.Content)
    
    fprintf('\tEmpty\n');
    
else
    
    tmp = cellfun(@format_link, this.Content, 'UniformOutput', false);
    
    numRows = ceil(numel(tmp)/in.numCols);
    if numel(tmp)<numRows*in.numCols
        tmp{numRows*in.numCols} = [];
    end
    tmp = reshape(tmp, [in.numCols numRows])';
    
    fprintf('\n');
    ML.Text.table(tmp, 'style', 'compact', 'border', 'none')

end

    % --- Nested functions ------------------------------------------------
    function out = format_link(in)
        
        [~, x] = fileparts(in);
        if strcmp(x(1), '+'), x = x(2:end); end
        out = ['<a href="matlab:ML.search(''' this.Syntax '.' x ''', ''verbose'', false);">' x '</a>'];
        
    end

end