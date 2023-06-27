% Merges the fields of two or more datasets.
%
%     output = clumerge(datasets, varargin)
%
% Merges the fields (specified in `fields`) of two or more `datasets`
% (cell of structs). The fields to be merged need to have the same number
% of columns. The corresponding merged field will contain the rows of the
% fields to be merged, and will have a common supertype.
%
% ## Arguments (mandatory)
%
% - `datasets`: Cell of structs, each struct containing a cluster data set
%    whose `fields` are to be merged.
%
% ## Arguments (optional)
%
% - `fields`: Fields to be merged, which must exist in the given `datasets`
%    (structs).
% - `clusters_field`: Field containing the integer cluster labels. If
%   specified, cluster assignments in individual datasets will be updated
%   in the merged dataset so that clusters are considered separate.
%
% ## Return values
%
% A `struct`, the fields of which correspond to field names, and values to
% the merged numerical arrays.
%
% ## Notes
%
% The `clusters_field` parameter specifies a field containing integers that
% identify the cluster to which the respective points belongs to. If
% `clusters_field` is specified (by default it's specified as `'clusters'`,
% cluster assignments in individual datasets will be updated in the merged
% dataset so that clusters are considered separate. This parameter can be
% set to `''` (empty char array), in which case no field will be considered
% as a special cluster assignments field.
%
% This function can be used to merge data sets (structs) generated with the
% `clugen()` function, by default merging the `points` and `clusters`
% fields in those data sets. It also works with arbitrary data by
% specifying alternative fields in the `fields` parameter. It can be used,
% for example, to merge third-party data with `clugen()`-generated data.
%
% ## Examples
%
%     o1 = clugen(2, 4, 400, [1 0], pi / 8, [50, 10], 20, 1, 2);
%     o2 = clugen(2, 3, 200, [1 0.5], pi / 4, [50, 50], 10, 0.1, 2.1);
%     om = clumerge({o1, o2});
function output = clumerge(datasets, varargin)

    % Setup input validation
    p = inputParser;

    % Check that datasets is a cell with at least one dataset
    addRequired(p, 'datasets', @(x) iscell(x) && numel(x) > 0);

    % Check that fields is a cell with at least one field
    addParameter(p, 'fields', {'points', 'clusters'}, ...
        @(x) iscell(x) && numel(x) > 0);

    % Check that clusters_field is a string
    addParameter(p, 'clusters_field', 'clusters', @(x) ischar(x));

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
    fields_set = reshape(p.Results.fields, [1 numel(p.Results.fields)]);

    % If the clusters_field parameter is given, make sure it exists in the
    % set of fields
    if (numel(clusters_field) > 0) && ...
            ~any(ismember(fields_set, clusters_field))
        fields_set = [fields_set, clusters_field];
    end;

    % Make sure datasets cell array is a row vector
    if size(datasets, 1) > 1
        datasets = reshape(datasets, [1 numel(datasets)]);
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
                    num2str(nelems_tmp), ' ~= ', num2str(nelems_i), ')']);

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

    % Copy items from input data to output dictionary, field-wise
    copied = 0;
    last_cluster = 0;

    % Create merged output
    for dtc = datasets

        dt = dtc{:};

        % How many elements to copy for the current data item?
        tocopy = size(dt.(fields_set{1}), 1);

        % Cycle through each field and its information
        for fld = transpose(fieldnames(fields_info))

            % Copy elements
            if strcmp(fld{:}, clusters_field)

                % If this is a clusters field, update the cluster IDs
                old_clusters = unique(dt.(clusters_field));
                new_clusters = (last_cluster + 1):(last_cluster + numel(old_clusters));
                mapping = containers.Map(old_clusters, new_clusters);
                last_cluster = new_clusters(end);
                output.(fld{:})((copied + 1):(copied + tocopy)) = ...
                    arrayfun(@(x) mapping(x), dt.(clusters_field));
            else

                % Otherwise just copy the elements
                output.(fld{:})((copied + 1):(copied + tocopy), :) = dt.(fld{:});
            end;
        end

        % Update how many were copied so far
        copied = copied + tocopy;

    end;

end % function clumerge()

function t = common_supertype(type1, type2)

    type_set = { type1, type2 };
    validtypes = {'logical', 'int8', 'uint8', 'int16', 'uint16', ...
        'int32', 'uint32', 'int64', 'uint64', 'char', 'single', 'double'};

    if strcmp(type1, type2)
        t = type1;
    elseif ~string_in(type1, validtypes)
        error(['Unsupported type `', type1 ,'`']);
    elseif ~string_in(type2, validtypes)
        error(['Unsupported type `', type2 ,'`']);
    elseif string_in('char', type_set)
        error('No common supertype between char and numerical type')
    elseif string_in('double', type_set)
        t = 'double';
    elseif string_in('single', type_set)
        t = 'single';
    else
        t = 'int64';
    end;

end % function common_supertype()

function b = string_in(str, str_cell)

    r = find(strcmp(str_cell, str));
    b = numel(r) > 0;

end % function string_in()

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
