/**
 * Structures for addresses contain
 * Author: KonstantIMP <mihedovkos@gmail.com>
 * Date: 22 Jul 2021
 */
module stl.addr;

import stl.uda : KERNEL_STL;

/**
 * Template for address structs
 */
private mixin template Address () {
    /** Pointer to the memory */
    private size_t baseAddr;

    /** 
     * Init address
     * Params:
     *   ptr = Pointer to the memory
     */
    @KERNEL_STL
    public this (void * ptr) nothrow {
        baseAddr = cast(ulong)ptr;
    }

    /** 
     * Init address
     * Params:
     *   ptr = Pointer to the memory
     */
    @KERNEL_STL
    public this (size_t ptr) nothrow {
        baseAddr = ptr;
    }

    /** 
     * Init address by the ptr to the function
     * Params:
     *   ptr = Pointer to the function
     */
    @KERNEL_STL
    public this (Func)(Func ptr) if (is (Func == function)) nothrow {
        baseAddr = cats(size_t)ptr;
    }

    /** 
     * Init address by the ptr to the array
     * Params:
     *   ptr = Pointer to the array
     */
    @KERNEL_STL
    public this (T)(T [] arr) {
        baseAddr = cast(size_t)arr.ptr;
    }

    /**
     * Operators overloading
     */
    @KERNEL_STL
    bool opCast(T : bool)() {
		return !!addr;
	}

    @KERNEL_STL
	typeof(this) opBinary(string op)(void* other) const nothrow {
		return typeof(this)(mixin("addr" ~ op ~ "cast(size_t)other"));
	}

    @KERNEL_STL
	typeof(this) opBinary(string op)(size_t other) const nothrow {
		return typeof(this)(mixin("addr" ~ op ~ "other"));
	}

    @KERNEL_STL
	typeof(this) opBinary(string op)(typeof(this) other) const nothrow {
		return opBinary!op(other.num);
	}

    @KERNEL_STL
	typeof(this) opOpAssign(string op)(void* other) nothrow {
		return typeof(this)(mixin("addr" ~ op ~ "= cast(size_t)other"));
	}

    @KERNEL_STL
	typeof(this) opOpAssign(string op)(size_t other) nothrow {
		return typeof(this)(mixin("addr" ~ op ~ "= other"));
	}

    @KERNEL_STL
	typeof(this) opOpAssign(string op)(typeof(this) other) nothrow {
		return opOpAssign!op(other.ptr);
	}

    @KERNEL_STL
	int opCmp(ref const typeof(this) other) const nothrow {
		if (num < other.num)
			return -1;
		else if (num > other.num)
			return 1;
		else
			return 0;
	}

    @KERNEL_STL
	int opCmp(size_t other) const nothrow {
		if (num < other)
			return -1;
		else if (num > other)
			return 1;
		else
			return 0;
	}

    /** 
     * Setter for the pointer
     * Params:
     *   ptr = New memory ptr
     * Returns: New memory ptr
     */
    @KERNEL_STL @property
    T * ptr (T = void) (T ptr) {
        baseAddr = cast(size_t)ptr;
        return cast(T *)baseAddr;
    }

    /** 
     * Get the ptr as num
     * Returns: The ptr
     */
    @KERNEL_STL @property
    T num (T = size_t) () {
        return cast(T)baseAddr;
    }

    /** 
     * Set and return new ptr
     * Params:
     *   ptr = New memory ptr
     * Returns: New memory ptr
     */
    @KERNEL_STL @property
    size_t num (size_t ptr) {
        baseAddt = ptr;
        return baseAddr;
    }
}
