use "net"
use "net/http"
use log = "logger"


class val LoggingHandlerFactory is HandlerFactory
  """
  LoggingHanderFactory creates a logging handler that
  does nothing but logging each call.
  """
  let logger: log.Logger[String val]

  new val create(logger': log.Logger[String val]) =>
    logger = logger'
    logger(log.Fine) and logger.log("LoggingHandlerFactory.create")

  fun apply(session: HTTPSession tag) : HTTPHandler =>
    logger(log.Fine) and logger.log("LoggingHandlerFactory.apply")
    LoggingHandler(logger, session)


class LoggingHandler is HTTPHandler
  """
  LoggingHander does nothing but logging each call and writing
  the payload body.
  """
  let logger: log.Logger[String val]
  let session: HTTPSession

  new create(logger': log.Logger[String val], session': HTTPSession) =>
    logger = logger'
    session = session'
    logger(log.Fine) and logger.log("LoggingHandler.create")

  fun ref apply(payload: Payload val): Any =>
    logger(log.Fine) and logger.log("LoggingHandler.apply")
    // if payload.status 

  fun ref chunk(data: ByteSeq val) =>
    logger(log.Fine) and logger.log("LoggingHandler.chunk")
    match data
    | let s: String => 
      logger(log.Fine) and logger.log(s)
    | let d: Array[U8 val] val =>
      let s = String.from_array(d)
      logger(log.Fine) and logger.log(s)
    end

  fun ref finished() => 
    logger(log.Fine) and logger.log("LoggingHandler.finished")

  fun ref cancelled() =>
    logger(log.Fine) and logger.log("LoggingHandler.cancelled")

  fun ref throttled() =>
    logger(log.Fine) and logger.log("LoggingHandler.throttled")

  fun ref unthrottled() =>
    logger(log.Fine) and logger.log("LoggingHandler.unthrottled")

  fun ref need_body() =>
    logger(log.Fine) and logger.log("LoggingHandler.need_body")


  actor Main
    new create(env': Env) =>
      
      try
        let logger = log.StringLogger(log.Fine, env'.out)
        let factory = LoggingHandlerFactory(logger)

        let client = HTTPClient(env'.root as TCPConnectionAuth, None, false)
        let p1 = Payload.request("GET", URL.build("http://www.google.com"))
        logger(log.Fine) and logger.log("about to call client.apply")
        client(consume p1, factory)

        let p2 = Payload.request("GET", URL.build("http://www.google.com"))
        logger(log.Fine) and logger.log("about to call client.apply")
        client(consume p2, factory)
      end

