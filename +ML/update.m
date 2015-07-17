function update(varargin)
%ML.update Updates MLab
%
%   ML.UPDATES.UPDATE()
%
%   See also

% === Input variables =====================================================

in = ML.Input;
in.action('display') = @ischar;
in.check(true) = @islogical;
in.quiet(false) = @islogical;

in = +in;

% =========================================================================

% --- Get MLaab path
mpath = getpref('MLab', 'path');

list = ML.Updates.list('', 'quiet', true, 'check', in.check);

% --- Display

D = ML.Updates.CLI('Updates');
D.title = '~b{Updates}';
D.list = list;

D.structure

D.print();

% list

% Git = org.eclipse.jgit.api.Git.open(java.io.File([mpath '.git']));
% m = Git.pull.call;
