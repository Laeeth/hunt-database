/*
 * Copyright (C) 2018 Julien Viet
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
module hunt.database.postgresql.impl.codec.ExtendedQueryCommandCodec;

import hunt.database.postgresql.impl.codec.ExtendedQueryCommandBaseCodec;
import hunt.database.postgresql.impl.codec.PgEncoder;

import hunt.database.base.impl.command.ExtendedQueryCommand;

import hunt.collection.List;

class ExtendedQueryCommandCodec(R) : ExtendedQueryCommandBaseCodec!(R, ExtendedQueryCommand!(R)) {

    this(ExtendedQueryCommand!(R) cmd) {
        super(cmd);
    }

    override void encode(PgEncoder encoder) {
        if (cmd.isSuspended()) {
            encoder.writeExecute(cmd.cursorId(), cmd.fetch());
            encoder.writeSync();
        } else {
            PgPreparedStatement ps = cast(PgPreparedStatement) cmd.preparedStatement();
            if (ps.bind.statement == 0) {
                encoder.writeParse(new Parse(ps.sql()));
            }
            encoder.writeBind(ps.bind, cmd.cursorId(), cast(List!(Object)) cmd.params());
            encoder.writeExecute(cmd.cursorId(), cmd.fetch());
            encoder.writeSync();
        }
    }
}
