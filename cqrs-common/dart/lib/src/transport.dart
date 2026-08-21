/// How a request left the server, as `org.fuin.cqrs4j.core.ResultType` states it.
enum ResultType {
  /// The command was accepted.
  ok,

  /// Accepted, with something worth saying about it.
  warning,

  /// Refused. [CommandResult.message] is the model's own wording, written to be read by a person.
  error,
}

/// What `POST /cmd/<type>` answers.
class CommandResult {
  /// Constructor with all data.
  const CommandResult({required this.type, this.code, this.message});

  /// Reads the result off the server's JSON.
  factory CommandResult.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    return CommandResult(
      type: switch (type) {
        'OK' => ResultType.ok,
        'WARNING' => ResultType.warning,
        _ => ResultType.error,
      },
      code: json['code'] as String?,
      message: json['message'] as String?,
    );
  }

  /// Whether the write side accepted the command.
  final ResultType type;

  /// The rule that was violated, when it did not.
  final String? code;

  /// What to tell the user.
  final String? message;

  /// Whether the command was accepted.
  bool get accepted => type != ResultType.error;
}

/// Reads a view over whatever transport the application is wired with.
///
/// Declared here and implemented in `core_net` so this package stays pure Dart: the generated clients
/// know the paths and the types, and nothing about bearer tokens, retries or which HTTP library is in
/// use. It is the same split the JavaFX client makes between its query clients and `BackendHttp`.
abstract interface class ViewTransport {
  /// Issues a GET against [path], with [query] appended. Returns the decoded JSON body.
  Future<Object?> get(String path, {Map<String, Object?> query = const <String, Object?>{}});
}

/// Sends commands to the write side.
abstract interface class CommandTransport {
  /// Posts [body] to `/cmd/[type]` and returns what the write side answered.
  Future<CommandResult> post(String type, Map<String, Object?> body);
}
