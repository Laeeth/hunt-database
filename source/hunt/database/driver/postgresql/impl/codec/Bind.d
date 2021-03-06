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

module hunt.database.driver.postgresql.impl.codec.Bind;

import hunt.database.driver.postgresql.impl.codec.DataType;
import hunt.database.driver.postgresql.impl.codec.DataTypeDesc;
import hunt.database.driver.postgresql.impl.codec.PgColumnDesc;

/**
 * @author <a href="mailto:emad.albloushi@gmail.com">Emad Alblueshi</a>
 */
final class Bind {

    long statement;
    // DataType[] paramTypes;
    DataTypeDesc[] paramTypes;
    PgColumnDesc[] resultColumns;

    this(long statement, DataTypeDesc[] paramTypes, PgColumnDesc[] resultColumns) {
        this.statement = statement;
        this.paramTypes = paramTypes;
        this.resultColumns = resultColumns;
    }
}
