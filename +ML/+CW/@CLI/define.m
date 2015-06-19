function define(this)
% ML.CW.CLI/define Define CLI pages
%   ML.CW.CLI/define defines the lists of option in the pages of the CLI.
%   This method has to be overloaded. Sample code is provided below for
%   guidance.
%
%   See also ML.CW.CLI, ML.CW.CLI/add
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI.define');">ML.doc</a>

% === SAMPLE CODE TO OVERLOAD =============================================

% switch this.page
%    
%     case 'Main'
% 
%         % --- Page parameters
%         this.header = '\n';
%         this.footer = '\n';
%         this.case_sensitive = false;
%         
%         % --- Page options
%         this.add('a', 'First option', @a_opt);
%         this.add('b', 'Second option', @b_opt);
%         this.add('q', 'Quit', @stop);
%         
% end