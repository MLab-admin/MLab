function plugins(varargin)
%ML.plugins MLab plugins
%
%   See also ML.Plugins.list.

% === Input variables =====================================================

in = ML.Input;
in.message('') = @ischar;
in = +in;

% =========================================================================

% --- Get list of plugins
Ll = ML.Plugins.list('local')';
Lr = ML.Plugins.list('remote');
Ld = setdiff(Lr, Ll);

Ld = cellfun(@(x) ['<a href="matlab:ML.Plugins.install(''' x ''');">' x '</a>'], Ld, 'UniformOutput', false);

% --- Display

clc
fprintf('<strong>Plugins</strong>\n');

if ~isempty(in.message)
    fprintf('%s\n', in.message);
end

ML.Text.table([[Ll(:) ; cell(numel(Ld)-numel(Ll),1)] ...
       [Ld(:) ; cell(numel(Ll)-numel(Ld),1)]], ...
       'col', {'Installed', 'Available'}, 'style', 'compact');

