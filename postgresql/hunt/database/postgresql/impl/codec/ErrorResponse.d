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

module hunt.database.postgresql.impl.codec;

import hunt.database.postgresql.PgException;

/**
 * @author <a href="mailto:emad.albloushi@gmail.com">Emad Alblueshi</a>
 */

class ErrorResponse : Response {

  PgException toException() {
    return new PgException(getMessage(), getSeverity(), getCode(), getDetail());
  }

  override
  String toString() {
    return "ErrorResponse{" ~
      "severity='" ~ getSeverity() + '\'' +
      ", code='" ~ getCode() + '\'' +
      ", message='" ~ getMessage() + '\'' +
      ", detail='" ~ getDetail() + '\'' +
      ", hint='" ~ getHint() + '\'' +
      ", position='" ~ getPosition() + '\'' +
      ", internalPosition='" ~ getInternalPosition() + '\'' +
      ", internalQuery='" ~ getInternalQuery() + '\'' +
      ", where='" ~ getWhere() + '\'' +
      ", file='" ~ getFile() + '\'' +
      ", line='" ~ getLine() + '\'' +
      ", routine='" ~ getRoutine() + '\'' +
      ", schema='" ~ getSchema() + '\'' +
      ", table='" ~ getTable() + '\'' +
      ", column='" ~ getColumn() + '\'' +
      ", dataType='" ~ getDataType() + '\'' +
      ", constraint='" ~ getConstraint() + '\'' +
      '}';
  }
}
