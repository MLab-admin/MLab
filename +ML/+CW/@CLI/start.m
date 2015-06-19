function start(this)
%ML.CW.CLI/start Start CLI engine
%   ML.CW.CLI/start() starts and manages the Command-Line Interface until
%   the 'stop' method is called.
%
%   See also ML.CW.CLI, M.CW.CLI/stop
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.start');">ML.doc</a>

while ~this.quit

    % --- Define elements
    this.elms(:) = [];
    this.define;
    
    clc
    
    % --- Print message
    if ~isempty(this.message)
        fprintf('%s\n', this.message);
        this.message = '';
    end
    
    % --- Print header
    fprintf(this.header);
    
    % --- Print options
    for i = 1:numel(this.elms)
        fprintf('\t[%s] - %s\n', this.elms(i).key, this.elms(i).desc);
    end
    
    % --- Print footer
    fprintf(this.footer);
    
    % --- Prompt
    s = input('?> ', 's');
    
    switch s
        case ''
            
        otherwise
            
            if this.case_sensitive
                tf = strcmp({this.elms(:).key}, s);
            else
                tf = strcmpi({this.elms(:).key}, s);
            end
            
            if ~any(tf)
                this.message = ['The input ''' s ''' didn''t matched any option.'];
            else
                this.(this.elms(find(tf, 1, 'first')).action);
            end
    end
    
end 

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help.
%   1.0     (2015/04/02): Initial version.
%
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>