function check(varargin)
%ML.Updates.check Check MLAB updates
%
%   ML.UPDATES.CHECK()
%  
%   Reference page in Help browser: <a href="matlab:doc ML.Updates.check">doc ML.Updates.check</a>
%   <a href="matlab:doc ML">MLab documentation</a>

% === Input variables =====================================================

in = inputParser;
in.addParamValue('force', true, @islogical);
in.addParamValue('quiet', true, @islogical);

in.parse(varargin{:});
in = in.Results;

% =========================================================================

L = ML.Updates.get('force', in.force);
if ~isstruct(L), return; end

if numel(L.to_add) || numel(L.to_del)
    
    fprintf('<strong>MLab Update</strong>\n');
    txt = 'There ';
    if numel(L.to_add)+numel(L.to_del)==1
        txt = [txt 'is '];
    else
        txt = [txt 'are '];
    end
    
    if numel(L.to_add)
        txt = [txt num2str(numel(L.to_add)) ' file'];
        if numel(L.to_add)>1, txt(end+1) = 's'; end
        txt = [txt ' to add/update'];
    end

    if numel(L.to_del)
        if numel(L.to_add), txt = [txt ' and ']; end
        txt = [txt num2str(numel(L.to_del)) ' file'];
        if numel(L.to_del)>1, txt(end+1) = 's'; end
        txt = [txt ' to remove'];
    end
    
    fprintf('%s\n<a href="matlab:ML.Updates.update;">Click here</a> to see the list\n\n', txt);
            
else
    if ~in.quiet
        disp('MLab is up to date.');
    end
end

