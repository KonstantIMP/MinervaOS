/**
 * Struct for version containing
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module build.ver;

/** 
 * Contain full version : Major.Minor.Micro
 */
class Version {
    public size_t major;
    public size_t minor;
    public size_t micro;

    public this (size_t maj, size_t min, size_t mic) {
        major = maj; minor = min; micro = mic;
    }

    override public string toString() const {
        import std.format : format;
        return format("%s.%s.%s", major, minor, micro);
    }
}
