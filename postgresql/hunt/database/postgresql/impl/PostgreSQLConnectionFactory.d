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

module hunt.database.postgresql.impl.PostgreSQLConnectionFactory;

import hunt.database.postgresql.PostgreSQLConnectOptions;
import hunt.database.postgresql.SslMode;
import hunt.database.base.impl.Connection;
import hunt.database.base.impl.command.CommandResponse;
// import io.vertx.core.*;
// import io.vertx.core.impl.NetSocketInternal;
// import io.vertx.core.net.*;

import hunt.collection.HashMap;
import hunt.collection.Map;

/**
 * @author <a href="mailto:julien@julienviet.com">Julien Viet</a>
 */
// class PgConnectionFactory {

//     private NetClient client;
//     private Context ctx;
//     private bool registerCloseHook;
//     private string host;
//     private int port;
//     private SslMode sslMode;
//     private TrustOptions trustOptions;
//     private string hostnameVerificationAlgorithm;
//     private string database;
//     private string username;
//     private string password;
//     private Map!(string, string) properties;
//     private bool cachePreparedStatements;
//     private int preparedStatementCacheSize;
//     private int preparedStatementCacheSqlLimit;
//     private int pipeliningLimit;
//     private bool isUsingDomainSocket;
//     private Closeable hook;

//     PgConnectionFactory(Context context,
//                         bool registerCloseHook,
//                         PgConnectOptions options) {

//         hook = this::close;
//         this.registerCloseHook = registerCloseHook;

//         ctx = context;
//         if (registerCloseHook) {
//             ctx.addCloseHook(hook);
//         }

//         NetClientOptions netClientOptions = new NetClientOptions(options);

//         // Make sure ssl=false as we will use STARTLS
//         netClientOptions.setSsl(false);

//         this.sslMode = options.getSslMode();
//         this.hostnameVerificationAlgorithm = netClientOptions.getHostnameVerificationAlgorithm();
//         this.trustOptions = netClientOptions.getTrustOptions();
//         this.host = options.getHost();
//         this.port = options.getPort();
//         this.database = options.getDatabase();
//         this.username = options.getUser();
//         this.password = options.getPassword();
//         this.properties = new HashMap<>(options.getProperties());
//         this.cachePreparedStatements = options.getCachePreparedStatements();
//         this.pipeliningLimit = options.getPipeliningLimit();
//         this.preparedStatementCacheSize = options.getPreparedStatementCacheMaxSize();
//         this.preparedStatementCacheSqlLimit = options.getPreparedStatementCacheSqlLimit();
//         this.isUsingDomainSocket = options.isUsingDomainSocket();

//         this.client = context.owner().createNetClient(netClientOptions);
//     }

//     // Called by hook
//     private void close(VoidHandler completionHandler) {
//         client.close();
//         completionHandler.handle(Future.succeededFuture());
//     }

//     void close() {
//         if (registerCloseHook) {
//             ctx.removeCloseHook(hook);
//         }
//         client.close();
//     }

//     void connectAndInit(Handler!(AsyncResult!(Connection)) completionHandler) {
//         connect(ar -> {
//             if (ar.succeeded()) {
//                 PgSocketConnection conn = ar.result();
//                 conn.init();
//                 conn.sendStartupMessage(username, password, database, properties, completionHandler);
//             } else {
//                 completionHandler.handle(CommandResponse.failure(ar.cause()));
//             }
//         });
//     }

//     void connect(Handler!(AsyncResult!(PgSocketConnection)) handler) {
//         switch (sslMode) {
//             case DISABLE:
//                 doConnect(false, handler);
//                 break;
//             case ALLOW:
//                 doConnect(false, ar -> {
//                     if (ar.succeeded()) {
//                         handler.handle(Future.succeededFuture(ar.result()));
//                     } else {
//                         doConnect(true, handler);
//                     }
//                 });
//                 break;
//             case PREFER:
//                 doConnect(true, ar -> {
//                     if (ar.succeeded()) {
//                         handler.handle(Future.succeededFuture(ar.result()));
//                     } else {
//                         doConnect(false, handler);
//                     }
//                 });
//                 break;
//             case VERIFY_FULL:
//                 if (hostnameVerificationAlgorithm is null || hostnameVerificationAlgorithm.isEmpty()) {
//                     handler.handle(Future.failedFuture(new IllegalArgumentException("Host verification algorithm must be specified under verify-full sslmode")));
//                     return;
//                 }
//             case VERIFY_CA:
//                 if (trustOptions is null) {
//                     handler.handle(Future.failedFuture(new IllegalArgumentException("Trust options must be specified under verify-full or verify-ca sslmode")));
//                     return;
//                 }
//             case REQUIRE:
//                 doConnect(true, handler);
//                 break;
//             default:
//                 throw new IllegalArgumentException("Unsupported SSL mode");
//         }
//     }

//     private void doConnect(bool ssl, Handler!(AsyncResult!(PgSocketConnection)) handler) {
//         if (Vertx.currentContext() != ctx) {
//             throw new IllegalStateException();
//         }
//         SocketAddress socketAddress;
//         if (!isUsingDomainSocket) {
//             socketAddress = SocketAddress.inetSocketAddress(port, host);
//         } else {
//             socketAddress = SocketAddress.domainSocketAddress(host ~ "/.s.PGSQL." ~ port);
//         }

//         Promise!(NetSocket) promise = Promise.promise();
//         promise.future().setHandler(ar -> {
//             if (ar.succeeded()) {
//                 NetSocketInternal socket = (NetSocketInternal) ar.result();
//                 PgSocketConnection conn = newSocketConnection(socket);

//                 if (ssl && !isUsingDomainSocket) {
//                     // upgrade connection to SSL if needed
//                     conn.upgradeToSSLConnection(ar2 -> {
//                         if (ar2.succeeded()) {
//                             handler.handle(Future.succeededFuture(conn));
//                         } else {
//                             handler.handle(Future.failedFuture(ar2.cause()));
//                         }
//                     });
//                 } else {
//                     handler.handle(Future.succeededFuture(conn));
//                 }
//             } else {
//                 handler.handle(Future.failedFuture(ar.cause()));
//             }
//         });

//         try {
//             client.connect(socketAddress, null, promise);
//         } catch (Exception e) {
//             // Client is closed
//             promise.fail(e);
//         }
//     }

//     private PgSocketConnection newSocketConnection(NetSocketInternal socket) {
//         return new PgSocketConnection(socket, cachePreparedStatements, preparedStatementCacheSize, preparedStatementCacheSqlLimit, pipeliningLimit, ctx);
//     }
// }
