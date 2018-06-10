/*
 * Copyright (c) 2016-2018 elementary LLC. (https://github.com/elementary/vala-lint)
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

class UnitTest : GLib.Object {

    public static int main (string[] args) {

        var ellipsis_check = new ValaLint.Checks.EllipsisCheck ();
        assert_pass (ellipsis_check, "lorem ipsum");
        assert_pass (ellipsis_check, "lorem ipsum...");
        assert_warning (ellipsis_check, "lorem ipsum\"...\"");

        var naming_all_caps_check = new ValaLint.Checks.NamingAllCapsCheck ();
        assert_pass (naming_all_caps_check, "LOREM");
        assert_pass (naming_all_caps_check, "LOREM_IPSUM");
        assert_warning (naming_all_caps_check, "lOREM");
        assert_warning (naming_all_caps_check, "LOREm");
        assert_warning (naming_all_caps_check, "LOREM-IPSUM");

        var naming_camel_case_check = new ValaLint.Checks.NamingCamelCaseCheck ();
        assert_pass (naming_camel_case_check, "Lorem");
        assert_pass (naming_camel_case_check, "LoremIpsum");
        assert_pass (naming_camel_case_check, "HTTPConnection");
        assert_warning (naming_camel_case_check, "lorem");
        assert_warning (naming_camel_case_check, "loremIpsum");
        assert_warning (naming_camel_case_check, "lorem_ipsum");
        assert_warning (naming_camel_case_check, "lorem-ipsum");

        var naming_underscore_check = new ValaLint.Checks.NamingUnderscoreCheck ();
        assert_pass (naming_underscore_check, "lorem");
        assert_pass (naming_underscore_check, "lorem_ipsum");
        assert_warning (naming_underscore_check, "Lorem");
        assert_warning (naming_underscore_check, "Lorem_Ipsum");
        assert_warning (naming_underscore_check, "lorem_IPsum");

        var tab_check = new ValaLint.Checks.TabCheck ();
        assert_pass (tab_check, "lorem ipsum");
        assert_warning (tab_check, "lorem	ipsum");

        var trailing_whitespace_check = new ValaLint.Checks.TrailingWhitespaceCheck ();
        assert_pass (trailing_whitespace_check, "lorem ipsum");
        assert_warning (trailing_whitespace_check, "lorem ipsum ");

        var block_parenthesis_check = new ValaLint.Checks.BlockOpeningBraceSpaceBeforeCheck ();
        assert_pass (block_parenthesis_check, "test () {");
        assert_warning (block_parenthesis_check, "test (){");
        assert_warning (block_parenthesis_check, "test ()\n{");
        assert_warning (block_parenthesis_check, "test ()   {");
        return 0;
    }

    private static void assert_pass (ValaLint.Check check, string input) {
        var parser = new ValaLint.Parser ();
        var parsed_result = parser.parse (input);
        var mistakes = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        check.check (parsed_result, ref mistakes);
        assert (mistakes.size == 0);
    }

    private static void assert_warning (ValaLint.Check check, string input, int char_pos = -1) {
        var parser = new ValaLint.Parser ();
        var parsed_result = parser.parse (input);
        var mistakes = new Gee.ArrayList<ValaLint.FormatMistake?> ();
        check.check (parsed_result, ref mistakes);
        assert (mistakes.size > 0);
        if (char_pos > -1) {
            assert (mistakes[0].char_index == char_pos);
        }
    }
}
