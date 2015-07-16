function set(varargin)
%ML.Session.set Set a session variable
%   ML.Session.set('group', 'var', val) sets the value of the variable 'var'
%   in 'group'. group must and var must be valid Matlab names.
%
%   Note: this function is akin to the built-in <a href="matlab:doc setpref">setpref</a>, except that the
%   variables are not kept from one session to another.
%
%   See also ML.Session.get, setpref
%
%   More on <a href="matlab:ML.doc('ML.Session.set');">ML.doc</a>.

% --- Inputs
in = ML.Input;
in.group = @isvarname;
in.var = @isvarname;
in.value = @(x) true;
in = +in;

% --- Get group
UD = get(groot, 'Userdata');
if ~isstruct(UD), UD = struct(); end

if ~isfield(UD, in.group)
    UD.(in.group) = struct();
end

% --- Set variable
UD.(in.group).(in.var) = in.value;

% --- Store user data
set(groot, 'Userdata', UD);



