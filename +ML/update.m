function update(varargin)
%ML.update Updates MLab
%
%   ML.UPDATES.UPDATE()
%
%   See also

% TO DO: 
% - Exploit message 'm' in the update method
% - Re-check after update
% - Message if everything is up to date (instead of CLI).

% === Input variables =====================================================

in = ML.Input;
in.action('display') = @ischar;
in.check(true) = @islogical;
in.quiet(false) = @islogical;

in = +in;

% =========================================================================

list = ML.Updates.list('', 'quiet', true, 'check', in.check);

% --- Display

D = ML.Updates.CLI('Updates');
D.title = '~b{Updates}';
D.list = list;

D.print('style', 'compact', 'border', 'none');