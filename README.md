# Quiz Proctoring Canvas Plugin

This plugin enables proctored quizzes inside of Canvas.

## Installation

```sh
sysadmin@appserver:~$ cd /path/to/canvas/gems/plugins
sysadmin@appserver:/path/to/canvas/gems/plugins$ git clone https://github.com/atomicjolt/quiz_proctor_engine.git
```

Now `bundle install` and `bundle exec rake canvas:compile_assets` and `rails server`.

After it is up, login with the site admin account and head over to the `/plugins` route (Navigated to by clicking `Admin -> Site Admin -> Plugins`).
Once there, scroll down to `Quiz Proctor Engine` and click into it. Enable the plugin and add your shared secret and adhesion url.

You should be all set now. Enjoy!
