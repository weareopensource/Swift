import AuthenticationServices

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDProvider {
    public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        let request = base.createRequest()
        request.requestedScopes = scope

        let controller = ASAuthorizationController(authorizationRequests: [request])

        let proxy = ASAuthorizationControllerProxy.proxy(for: controller)

        controller.presentationContextProvider = proxy
        controller.performRequests()

        return proxy.didComplete
    }
}

@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDButton {
    public func loginOnTap(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        return controlEvent(.touchUpInside)
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.login(scope: scope)
            }
    }

    public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        return ASAuthorizationAppleIDProvider().rx.login(scope: scope)
    }
}
