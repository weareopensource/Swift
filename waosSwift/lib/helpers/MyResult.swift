/**
 * Model Result
 */

public enum MyResult<T, E> {
    case success(T)
    case error(E)
}
