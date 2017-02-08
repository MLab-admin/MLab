function require(pname)
%ML.Plugins.require requires plugins and propose installation
%   ML.PLUGINS.REQUIRE(PNAME) checks if the plugin PNAME is installed and,
%   if not, proposes installation. PNAME can be either a string or a cell
%   of strings. If PNAME is a cell of strings, successive installations
%   will be proposed. If one of the installation is declined or aborted, an
%   error is generated.
%
%   See also ML.plugins.

% === Input variables =====================================================

in = inputParser;
in.addRequired('pname', @(x) ischar(x) || iscellstr(x));

in.parse(pname);
in = in.Results;

% =========================================================================

% --- Get Plugins list
L = ML.Plugins.list('local');
P = in.pname(~ismember(in.pname, L));

if ~ML.Plugins.install(P)
	error('MLab:Plugins', 'Required MLab plugins are not installed.');
end
