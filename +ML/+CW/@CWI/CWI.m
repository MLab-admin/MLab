classdef CWI<handle
% ML.CW.CWI Command Window Interface
%   This class creates a clickable interface in the command window. The
%   interface has the form of a 2D grid in which every square can contain
%   an interactive element (input, selectable field or link).
%
%   --- Syntax
%
%   ML.CW.CWI creates a CWI object.
%
%   --- Usage
%
%   The following methods can be used to place a new element in the grid:
%       - <a href="matlab: help ML.CW.CWI.text">text</a>:   adds a textual element (not interactive)
%       - <a href="matlab: help ML.CW.CWI.select">select</a>: adds a selectable element. It supports multiple choices
%                 and multiple selections.
%       - <a href="matlab: help ML.CW.CWI.input">input</a>:  adds an input field
%       - <a href="matlab: help ML.CW.CWI.action">action</a>: adds an action (link)
%
%   Once all elements are placed on the grid, use the <a href="matlab: help ML.CW.CWI.print">print</a> method to 
%   display the interface.
%
%   See also ML.CW.CLI
%
%   More on <a href="matlab:ML.doc('ML.CW.CWI');">ML.doc</a>


    % --- Properties
    properties (SetAccess = private)
        objname = '';
        print_param = {};
    end
    
    properties (SetAccess = protected)
        elms = {};
    end
    
    % --- Constructor
    methods
        
        function this = CWI()
            
        end
        
    end
end

%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.0
%
%! Revisions
%   1.0     (2015/04/07): Initial version.
%
%! To_do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>