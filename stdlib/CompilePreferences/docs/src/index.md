# CompilePreferences

!!! compat "Julia 1.6"
    Julia's `CompilePreferences` API requires at least Julia 1.6.

`CompilePreferences` support embedding a simple `Dict` of metadata for a package on a per-project basis.  These preferences allow for packages to set simple, persistent pieces of data, and trigger recompilation of the package when the preferences change, to allow for customization of package behavior at compile-time.

## API Overview

`CompilePreferences` are used primarily through the `@load_preferences`, `@save_preferences` and `@modify_preferences` macros.  These macros will auto-detect the UUID of the calling package, throwing an error if the calling module does not belong to a package.  The function forms can be used to load, save or modify preferences belonging to another package.

Example usage:

```julia
using CompilePreferences

function get_preferred_backend()
    prefs = @load_preferences()
    return get(prefs, "backend", "native")
end

function set_backend(new_backend)
    @modify_preferences!() do prefs
        prefs["backend"] = new_backend
    end
end
```

Preferences are stored within the first `Project.toml` that represents an environment that contains the given UUID, even as a transitive dependency.
If no project that contains the given UUID is found, the preference is recorded in the `Project.toml` file of the currently-active project.
The initial state for preferences is an empty dictionary, package authors that wish to have a default value set for their preferences should use the `get(prefs, key, default)` pattern as shown in the code example above.

# API Reference

!!! compat "Julia 1.6"
    Julia's `CompilePreferences` API requires at least Julia 1.6.

```@docs
CompilePreferences.load_preferences
CompilePreferences.@load_preferences
CompilePreferences.save_preferences!
CompilePreferences.@save_preferences!
CompilePreferences.modify_preferences!
CompilePreferences.@modify_preferences!
CompilePreferences.clear_preferences!
CompilePreferences.@clear_preferences!
```