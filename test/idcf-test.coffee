{IDCF} = require '../src/idcf'
assert = require 'power-assert'
request = require 'request'
sinon = require 'sinon'

describe 'IDCF', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @endpoint = 'https://compute.jp-east.idcfcloud.com/client/api'
    @apiKey = 'XXX'
    @secretKey = 'YYY'
    @idcf = new IDCF { @endpoint, @apiKey, @secretKey }

  afterEach ->
    @sinon.restore()

  describe '#constructor', ->
    it 'should be defined as function', ->
      assert IDCF
      assert typeof IDCF is 'function'
      assert @idcf.endpoint is @endpoint
      assert @idcf.apiKey is @apiKey
      assert @idcf.secretKey is @secretKey

  describe '#request', ->
    context 'when resolved', ->
      beforeEach ->
        @response = body: { xyz: 456 }
        @stub = @sinon.stub request, 'Request', ({ callback }) =>
          callback null, @response

      it 'works', ->
        @idcf.request 'COMMAND!', abc: 123
        .then (result) =>
          assert @stub.callCount is 1
          assert @stub.getCall(0).args[0].json is true
          assert @stub.getCall(0).args[0].url is @endpoint
          assert @stub.getCall(0).args[0].qs.apiKey is @apiKey
          assert @stub.getCall(0).args[0].qs.command is 'COMMAND!'
          assert @stub.getCall(0).args[0].qs.response is 'json'
          assert.deepEqual result, @response

    context 'when resolved and contained errorcode', ->
      beforeEach ->
        @response = body: { xyz: { errorcode: '789' } }
        @stub = @sinon.stub request, 'Request', ({ callback }) =>
          callback null, @response

      it 'works', ->
        @idcf.request 'COMMAND!', abc: 123
        .catch (e) =>
          assert @stub.callCount is 1
          assert @stub.getCall(0).args[0].json is true
          assert @stub.getCall(0).args[0].url is @endpoint
          assert @stub.getCall(0).args[0].qs.apiKey is @apiKey
          assert @stub.getCall(0).args[0].qs.command is 'COMMAND!'
          assert @stub.getCall(0).args[0].qs.response is 'json'
          assert e instanceof Error
          assert.deepEqual e.response, @response

    context 'when rejected', ->
      beforeEach ->
        @error = new Error 'ERROR!'
        @stub = @sinon.stub request, 'Request', ({ callback }) =>
          callback @error, null

      it 'works', ->
        @idcf.request 'COMMAND!', abc: 123
        .catch (e) =>
          assert @stub.callCount is 1
          assert @stub.getCall(0).args[0].json is true
          assert @stub.getCall(0).args[0].url is @endpoint
          assert @stub.getCall(0).args[0].qs.apiKey is @apiKey
          assert @stub.getCall(0).args[0].qs.command is 'COMMAND!'
          assert @stub.getCall(0).args[0].qs.response is 'json'
          assert e instanceof Error
          assert.deepEqual e, @error

  describe '#_buildSignature', ->
    it 'works', ->
      query =
        apiKey: @apiKey
        command: 'listZones'
        response: 'json'
      signature = @idcf._buildSignature query, @secretKey
      assert signature is 'wWTwUIFBdRW7ep/xvNmmbj90ykI='

  describe '#_request', ->
    context 'when resolved', ->
      beforeEach ->
        @response = body: { xyz: 456 }
        @stub = @sinon.stub request, 'Request', ({ callback }) =>
          callback null, @response

      it 'works', ->
        @idcf._request abc: 123
        .then (result) =>
          assert @stub.callCount is 1
          assert @stub.getCall(0).args[0].abc is 123
          assert.deepEqual result, @response

    context 'when rejected', ->
      beforeEach ->
        @error = new Error 'ERROR!'
        @stub = @sinon.stub request, 'Request', ({ callback }) =>
          callback @error, null

      it 'works', ->
        @idcf._request abc: 123
        .catch (e) =>
          assert @stub.callCount is 1
          assert @stub.getCall(0).args[0].abc is 123
          assert.deepEqual e, @error
