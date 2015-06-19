function print(this, varargin)
%ML.CW.CLI/print
%   ML.CW.CWI/print() prints the grid of the CWI in the command window.
%
%   ML.CW.CWI/print(..., 'option', OPT) specifies options to modify the
%   default printing behavior, like row/column headers or appearance. The 
%   possible options are the one accepted by <a href="matlab:help ML.Text.table;">ML.Text.table</a>.
%
%   See also ML.CW.CWI, ML.CW.CWI/text, ML.CW.CWI/input, ML.CW.CWI/select, ML.CW.CWI/action
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI.print');">ML.doc</a>

% --- First call: store informations
if isempty(this.objname)
    this.objname = inputname(1);
end

if isempty(this.print_param)
    this.print_param = varargin;
else
    varargin = this.print_param;
end

% --- 
T = cell(size(this.elms));
for i = 1:numel(this.elms)
    if ~isempty(this.elms{i})
        
        switch this.elms{i}.type
            
            case 'text'
                T{i} = this.elms{i}.text;
                
            case 'input'
                
                T{i} = {};
                if ~isempty(this.elms{i}.desc)
                    T{i}{1} = this.elms{i}.desc;
                end
                
                T{i}{end+1} = ['<a href="matlab:' this.objname '.get_input(' ...
                    num2str(i) ');">[' this.elms{i}.value ']</a>'];
                
            case 'select'
                
                T{i} = {};
                if ~isempty(this.elms{i}.desc)
                    T{i}{1} = this.elms{i}.desc;
                end
                
                for j = 1:numel(this.elms{i}.list)
                                        
                    T{i}{end+1} = ['<a href="matlab:' this.objname '.toggle(' ...
                        num2str(i) ',' num2str(j) ');">' this.elms{i}.symbols{this.elms{i}.values(j)+1} ...
                        '</a> ' this.elms{i}.list{j}];
                end
                
            case 'action'
                T{i} = ['<a href="matlab:' this.objname '.' this.elms{i}.action ...
                    '();">' this.elms{i}.desc '</a>'];
                
        end
    end
end

% --- Display
ML.Text.table(T, varargin{:});

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Improved display of 'select' elements , created
%               help.
%   1.0     (2015/04/06): Initial version.
%
%! To do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>