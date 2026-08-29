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
  const CommandResult({required this.type, this.code, this.message, this.dataClass, this.data});

  /// Reads the result off the server's JSON.
  ///
  /// A refusal that carries data names both the class it is and the element it travels under, and the
  /// payload sits under that element's own name - so nothing here has to guess which field is the data.
  factory CommandResult.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final element = json['data-element'] as String?;
    return CommandResult(
      type: switch (type) {
        'OK' => ResultType.ok,
        'WARNING' => ResultType.warning,
        _ => ResultType.error,
      },
      code: json['code'] as String?,
      message: json['message'] as String?,
      dataClass: json['data-class'] as String?,
      data: element == null ? null : json[element] as Map<String, dynamic>?,
    );
  }

  /// Whether the write side accepted the command.
  final ResultType type;

  /// What kind of problem it was, e.g. `MELK-DUPLICATE_CATEGORY_NAME`.
  ///
  /// Readable on purpose: it is what a support desk quotes to categorise a problem. It says the kind,
  /// never the detail - that is what [data] is for.
  final String? code;

  /// What to tell the user.
  final String? message;

  /// The Java class of [data], as the server names it.
  ///
  /// Carried so a client that wants the typed shape can dispatch on it. A client reading the values
  /// generically does not need it.
  final String? dataClass;

  /// What the refusal was about, keyed by the model's own attribute names.
  ///
  /// `null` where the refusal carries nothing - most do not. Where it does, the keys are the attributes
  /// of the exception the model declares, which is what lets a form show the message under the field
  /// the rule was about instead of above the form.
  final Map<String, dynamic>? data;

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
