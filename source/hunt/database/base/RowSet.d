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

module hunt.database.base.RowSet;

import hunt.database.base.AsyncResult;
import hunt.database.base.Row;
import hunt.database.base.RowIterator;
import hunt.database.base.SqlResult;

import hunt.util.Common;

alias RowSetHandler = AsyncResultHandler!RowSet;
alias RowSetAsyncResult = AsyncResult!RowSet;

import std.variant;

/**
 * A set of rows.
 */
interface RowSet : Iterable!(Row), SqlResult!(RowSet) {

    RowIterator iterator();

    // override RowSet next();

    alias getAs = bind;

    final T[] bind(T, alias getColumnNameFun="b")() if(is(T == struct)) {
        T[] r = new T[this.rowCount()];
        size_t index = 0;
        foreach(Row row; this) {
            r[index] = row.bind!(T, getColumnNameFun)();
            index++;
        }

        return r;
    }

    final T[] bind(T, bool traverseBase=true, alias getColumnNameFun="b")() if(is(T == class)) {
        T[] r = new T[this.rowCount()];
        size_t index = 0;
        foreach(Row row; this) {
            r[index] = row.bind!(T, traverseBase, getColumnNameFun)();
            index++;
        }

        return r;
    }

    Row firstRow();
    
    Row lastRow();
    
    final T columnInLastRow(T = int)(string name) {
        T r = T.init;
        foreach(Row row; this) {
            Variant v = row.getValue(name);
            r = v.get!T();
        }

        return r;
    }
}
