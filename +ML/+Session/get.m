function out = get(varargin)
%ML.Session.get Get a session variable
%   val = ML.Session.get('group', 'var') gets the value of the variable 'var'
%   in 'group'. group must and var must be valid Matlab names.
%
%   val = ML.Session.get(..., 'quiet', true) does not return warnings if
%   the varaible is not found.
%
%   Note: this function is akin to the built-in <a href="matlab:doc getpref">getpref</a>, except that the
%   variables are not kept from one session to another.
%
%   See also ML.Session.set, getpref
%
%   More on <a href="matlab:ML.doc('ML.Session.get');">ML.doc</a>.

% --- Inputs
in = ML.Input;
in.group = @isvarname;
in.var = @isvarname;
in.quiet(false) = @islogical;
in = +in;

% --- Get group
UD = get(groot, 'Userdata');
if isfield(UD, in.group) && isstruct(UD.(in.group))
    
    % --- Get variable
    if isfield(UD.(in.group), in.var)
        out = UD.(in.group).(in.var);
    else
        if ~in.quiet
            warning('ML:Session:get:NoVariable', ['No variable ''' in.var ''' could be found in the group ''' in.group '''. NaN returned.']);
        end
        out = NaN;
    end
    
else
    if ~in.quiet
        warning('ML:Session:get:NoGroup', ['No group ''' in.group ''' could be found. NaN returned.']);
    end
    out = NaN;
end




