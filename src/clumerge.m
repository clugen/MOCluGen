function output = clumerge(datasets, varargin)

    % Setup input validation
    p = inputParser;

    % Check that datasets is a cell with at least one dataset
    addRequired(p, 'datasets', @(x) iscell(x) && numel(x) > 0);

    % Check that fields is a cell with at least one field
    addParameter(p, 'fields', {'points', 'clusters'}, ...
        @(x) iscell(x) && numel(x) > 0);

    % Check that clusters_field is a string
    addParameter(p, 'clusters_field', 'clusters', @(x) isstring(x));

    % Perform input validation and parsing
    parse(p, datasets, varargin{:});

    % Number of elements in each array the merged dataset
    nelems = 0;

    % Contains information about each field
    fields_info = struct();

    % Merged dataset to output, initially empty
    output = struct();

    % Get clusters field from parameters
    clusters_field = p.Results.clusters_field;

    % Set of fields
    fields_set = p.Results.fields;

    % If the clusters_field parameter is given, make sure it exists in the
    % set of fields
    if (numel(clusters_field) > 0) && ...
            ~any(ismember(fields_set, clusters_field))
        fields_set = [fields_set, clusters_field];
    end;

    % Cycle through data items
    for dtc = datasets

        % Number of elements in the current item
        nelems_i = NaN;

        % Check if current element is a struct
        dt = dtc{:};
        if ~isstruct(dt)
            error('One or more items in `datasets` are not structs.');
        end;

        % Cycle through fields for the current item
        for fld = fields_set

            if ~isfield(dt, fld{:})
                error(['Data item does not contain required field `', ...
                    fld{:} ,'`']);
            elseif strcmp(fld{:}, clusters_field) && ~isinteger(dt.(clusters_field))
                error(['`', clusters_field, '` must contain integer types']);
            end;

            % Get the field value
            value = dt.(fld{:});

            % Number of elements in field value
            nelems_tmp = size(value, 1);

            % Check the number of elements in the field value
            if isnan(nelems_i)

                % First field: get number of elements in value (must be the same
                % for the remaining field values)
                nelems_i = nelems_tmp;

            elseif nelems_tmp ~= nelems_i

                % Fields values after the first must have the same number of
                % elements
                error(['Data item contains fields with different sizes (', ...
                    nelems_tmp, ' ~= ', nelems_i]);

            end;

            % Get/check info about the field value type
            if ~isfield(fields_info, fld{:})

                % If it's the first time this field appears, just get the info
                fields_info.(fld{:}) = struct(...
                    'type', class(value), ...
                    'ncol', size(value, 2));

            else

                % If this field already appeared in previous data items, get the
                % info and check/determine its compatibility with respect to
                % previous data items
                if size(value, 2) ~= fields_info.(fld{:}).ncol
                    % Number of columns must be the same
                    error(['Dimension mismatch in field `', fld{:},'`'])
                end;

                % Get the common supertype
                fields_info.(fld{:}).type = common_supertype(...
                    class(value), ...
                    fields_info.(fld{:}).type);

            end;

        end;

        % Update total number of elements
        nelems = nelems + nelems_i;

    end;
    
    % Initialize output struct fields with room for all items
    for fld = transpose(fieldnames(fields_info))
        output.(fld{:}) = zeros(...
            nelems, fields_info.(fld{:}).ncol, fields_info.(fld{:}).type);
    end;

end % function clumerge()

function t = common_supertype(type1, type2)
    
    type_set = { type1, type2 };
    validtypes = {'logical', 'int8', 'uint8', 'int16', 'uint16', ...
        'int32', 'uint32', 'int64', 'uint64', 'char', 'single', 'double'};
    
    if all(type1 == type2)
        t = type1;
    elseif ~validatestring(type1, validtypes)
        error(['Unsupported type `', type1 ,'`']);
    elseif ~validatestring(type2, validtypes)
        error(['Unsupported type `', type2 ,'`']);        
    elseif validatestring('char', type_set)
        error('No common supertype between char and numerical type')
    elseif validatestring('double', type_set)
        t = 'double';
    elseif validatestring('single', type_set)
        t = 'single';
    else
        t = 'int64';
    end;

end % function common_supertype()

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
