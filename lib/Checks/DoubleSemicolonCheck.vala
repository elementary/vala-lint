/*
 * Copyright (c) 2019 elementary LLC. (https://github.com/elementary/vala-lint)
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
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 */

public class ValaLint.Checks.DoubleSemicolonCheck : Check {
    public DoubleSemicolonCheck () {
        Object (
            title: "double-semicolon",
            description: _("Checks for unnecessary semicolons")
        );

        state = Config.get_state (title);
    }

    public override void check (Vala.ArrayList<ParseResult?> parse_result,
                                ref Vala.ArrayList<FormatMistake?> mistake_list) {

    }

    public void check_statement (Vala.CodeNode stmt,
                            ref Vala.ArrayList<FormatMistake?> mistake_list) {
        if (state == Config.State.OFF) {
            return;
        }

        var reference = stmt.source_reference.end;
        var offset = reference.pos[-1] == ';' ? -1 : 0; // End location can be off by one

        if (reference.pos[offset] == ';' && reference.pos[offset + 1] == ';') {
            var begin = Utils.shift_location (reference, offset + 2);
            var end = Utils.shift_location (begin, 1);

            add_mistake ({ this, begin, end, _("Unnecessary semicolon") }, ref mistake_list);
        }
    }

    public override bool apply_fix (Vala.SourceLocation begin, Vala.SourceLocation end, ref string contents) {
        var lines = contents.split ("\n");

        var line = lines[begin.line - 1];
        line = line[0:begin.column - 1] + line[begin.column:line.length];
        lines[begin.line - 1] = line;

        contents = string.joinv ("\n", lines);
        return true;
    }
}
