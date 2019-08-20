/*
 * Copyright (C) 2019, HuntLabs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

module hunt.database.base.impl.SqlResultBase;

import hunt.database.base.SqlResult;

import hunt.collection.List;

abstract class SqlResultBase(T, R) : SqlResult!(T) { //  extends SqlResultBase!(T, R)

    int _updated;
    List!(string) _columnNames;
    int _size;
    R _next;

    override
    List!(string) columnsNames() {
        return _columnNames;
    }

    override
    int rowCount() {
        return _updated;
    }

    override
    int size() {
        return _size;
    }

    override
    R next() {
        return _next;
    }
}
