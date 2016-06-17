function display(this)


% --- Header
ML.CW.print(' ~bc[50 100 150]{%s} (%s class)', this.Name, this.Category);
fprintf('\t\t[<a href="matlab:edit ''%s'';">Edit file</a>]' , this.Syntax);
fprintf('   [<a href="matlab:help ''%s'';">Help</a>]' , this.Syntax);
switch this.Category
    case {'Built-in', 'Matlab', 'Toolbox'}
        fprintf('   [<a href="matlab:doc ''%s'';">Doc</a>]\n' , this.Syntax);
    case {'MLab', 'Plugin'}
        fprintf('   [<a href="matlab:ML.doc(''%s'');">ML.Doc</a>]\n' , this.Syntax);
end

ML.CW.print('~c[100 175 175]{%s}\n', this.Fullpath);

% --- Properties

Prop = cell(1,2);

Prop{1,1} = '~c[gray]{Syntax}';
Prop{1,2} = this.Syntax;

% Parenthood
if isprop(this, 'Parents')
    if numel(this.Parents)==1
        Prop{end+1,1} = '~c[gray]{Parent}';
    else
        Prop{end+1,1} = '~c[gray]{Parents}';
    end
    
    tmp = [];
    for i = 1:numel(this.Parents)
        tmp = [tmp '<a href="matlab:ML.search(''' this.Parents{i} ''', ''verbose'', false);">' this.Parents{i} '</a>   '];
    end
    Prop{end,2} = tmp;
end


% Toolbox
if isprop(this, 'Toolbox')
    Prop{end+1,1} = '~c[gray]{Toolbox}';
    Prop{end,2} = this.Toolbox;
end

% Package
if isprop(this, 'Package')
    Prop{end+1,1} = '~c[gray]{Package}';
    Prop{end,2} = ['<a href="matlab:ML.search(''' this.Package ''', ''verbose'', false);">' this.Package '</a>\n'];
end

ML.Text.table(Prop, 'style', 'compact', 'border', 'none');

% --- Properties and methods ----------------------------------------------

% Get meta class
mcls = meta.class.fromName(this.Syntax);

% --- Properties
mcls
Paxs = cell(numel(mcls.PropertyList),1);
Prop = cell(numel(mcls.PropertyList),1);
if numel(mcls.PropertyList)
    Paxs(:) = {''};
    Prop(:) = {''};
end

for i = 1:numel(mcls.PropertyList)
    
    % Get acess
    if strcmp(mcls.PropertyList(i).GetAccess, 'public')
        Paxs{i} = [Paxs{i} 'G'];
    else
        Paxs{i} = [Paxs{i} '~c[gray]{G}'];
    end
    
    % Set acess
    if strcmp(mcls.PropertyList(i).SetAccess, 'public')
        Paxs{i} = [Paxs{i} 'S'];
    else
        Paxs{i} = [Paxs{i} '~c[gray]{S}'];
    end
    
    % Property
    if mcls.PropertyList(i).Hidden
        Prop{i} = ['~c[gray]{' mcls.PropertyList(i).Name '}'];
    else
        Prop{i} = mcls.PropertyList(i).Name;
    end
    
end

% --- Methods

Maxs = {};
Meth = {};

for i = 1:numel(mcls.MethodList)
    
    if ~exist([this.Fullpath filesep mcls.MethodList(i).Name '.m'], 'file') && ...
            ~exist([this.Fullpath filesep mcls.MethodList(i).Name '.p'], 'file')
        continue;
    end
    
    % Get acess
    if strcmp(mcls.MethodList(i).Access, 'public')
        Maxs{end+1,1} = 'P';
    else
        Maxs{end+1,1} = '~c[gray]{P}';
    end
    
    % Method
    if mcls.MethodList(i).Hidden
        Meth{end+1,1} = ['~c[gray]{' mcls.MethodList(i).Name '}'];
    else
        Meth{end+1,1} = ['<a href="matlab:ML.search(''' this.Syntax '.' mcls.MethodList(i).Name ''', ''verbose'', false);">' mcls.MethodList(i).Name '</a>'];
    end
    
end

% Display table
Nrows = max(numel(Prop), numel(Meth));
if numel(Prop)<Nrows
    Paxs(Nrows) = {''};
    Prop(Nrows) = {''};
end
if numel(Meth)<Nrows
    Maxs(Nrows) = {''};
    Meth(Nrows) = {''};
end

T = [Paxs Prop Maxs Meth];

ML.Text.table(T, 'style', 'compact', 'border', 'none', ...
    'col_headers', {'' 'Properties' '' 'Methods'});
