/*
 * Copyright (c) 2016-2021 elementary LLC. (https://github.com/vala-lang/vala-lint)
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
 *
 * Authored by: Darshak Parikh <darshak@protonmail.com>
 */

public class ValaLint.Fixer : Object {
    public void apply_fixes_for_file (File file, ref Vala.ArrayList<FormatMistake?> mistakes) throws Error, IOError {
        var filename = file.get_path ();
        string contents;
        FileUtils.get_contents (filename, out contents);

        var remaining_mistakes = new Vala.ArrayList<FormatMistake?> ((a, b) => a.equal_to (b));

        // Fix mistakes in reverse, so that the begin/end locations of subsequent mistakes are not affected
        for (int index = mistakes.size - 1; index >= 0; index--) {
            var mistake = mistakes.@get (index);
            var applied = mistake.check.apply_fix (mistake.begin, mistake.end, ref contents);

            if (!applied) {
                remaining_mistakes.add (mistake);
            }
        }

        mistakes = remaining_mistakes;

        mistakes.sort ((a, b) => {
            if (a.begin.line == b.begin.line) {
                return a.begin.column - b.begin.column;
            }
            return a.begin.line - b.begin.line;
        });

        FileUtils.set_contents (filename, contents);
    }
}
