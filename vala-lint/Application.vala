/*
 * Copyright (c) 2016 Vala-Lint Developers (https://github.com/MarcusWichelmann/Vala-Lint)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Marcus Wichelmann <marcus.wichelmann@hotmail.de>
 */

public class ValaLint.Application : GLib.Application {
    private Application () {
        Object (application_id: "de.marcusw.vala-lint",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE | ApplicationFlags.HANDLES_OPEN);
    }

    public override int command_line (ApplicationCommandLine command_line) {
        this.hold ();

        int res = handle_command_line (command_line);

        this.release ();
        return res;
    }

    private int handle_command_line (ApplicationCommandLine command_line) {
        bool print_version = false;

        string[] patterns;

        OptionEntry[] options = new OptionEntry[1];
        options[0] = { "version", 'v', 0, OptionArg.NONE, ref print_version, _("Display version"), null };

        string[] args = command_line.get_arguments ();
        string*[] _args = new string[args.length];

        for (int i = 0; i < args.length; i++) {
            _args[i] = args[i];
        }

        try {
            var option_context = new OptionContext ("- Vala-Lint");
            option_context.set_help_enabled (true);
            option_context.add_main_entries (options, null);

            unowned string[] tmp = _args;
            option_context.parse (ref tmp);

            patterns = tmp;
        } catch (OptionError e) {
            command_line.print (_("Error: %s") + "\n", e.message);
            command_line.print (_("Run '%s --help' to see a full list of available command line options.") + "\n", args[0]);

            return 0;
        }

        if (print_version) {
            command_line.print (_("Version: %s") + "\n", Config.VERSION);

            return 0;
        }

        try {
            do_checks (command_line, patterns);
        } catch (Error e) {
            command_line.print (_("Error: %s") + "\n", e.message);
        }

        return 0;
    }

    private void do_checks (ApplicationCommandLine command_line, string[] patterns) throws Error, IOError {
        var linter = new Linter ();

        foreach (string pattern in patterns) {
            var matcher = Posix.Glob ();

            if (matcher.glob (pattern) != 0) {
                command_line.print (_("Invalid pattern: %s") + "\n", pattern);

                return;
            }

            foreach (string path in matcher.pathv) {
                File file = File.new_for_path (path);
                FileType file_type = file.query_file_type (FileQueryInfoFlags.NONE);

                if (file_type != FileType.REGULAR) {
                    continue;
                }

                Gee.ArrayList<FormatMistake?> mistakes = linter.run_checks_for_file (file);

                if (!mistakes.is_empty) {
                    command_line.print ("\x001b[1m\x001b[4m" + "%s" + "\x001b[0m\n", path);

                    foreach (FormatMistake mistake in mistakes) {
                        command_line.print ("\x001b[0m%5i:%-3i \x001b[1m%-40s   \x001b[0m%s\n",
                            mistake.line_index,
                            mistake.char_index,
                            mistake.mistake,
                            mistake.check.get_title ());
                    }
                }
            }
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
