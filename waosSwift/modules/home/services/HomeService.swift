/**
 * Dependencies
 */

import RxSwift

/**
 * Service
 */

protocol HomeServiceType {
    var pages: Observable<[Pages]?> { get }

    func getPages(_ api: HomeApi) -> Observable<MyResult<PagesResponse, CustomError>>
}

final class HomeService: CoreService, HomeServiceType {
    fileprivate let networking = Networking<HomeApi>(plugins: [CookiePlugin()])

    // temporary array
    var defaultPages: [Pages] = [Pages()]

    fileprivate let pagesSubject = ReplaySubject<[Pages]?>.create(bufferSize: 1)
    lazy var pages: Observable<[Pages]?> = self.pagesSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func getPages(_ api: HomeApi) -> Observable<MyResult<PagesResponse, CustomError>> {
        log.verbose("🔌 service : get Pages")
        return self.networking
            .request(api)
            .map(PagesResponse.self)
            .map { response in
                self.defaultPages = response.data
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catch { err in .just(.error(getError(err)))}
    }
}
