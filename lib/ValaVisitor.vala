/*
 * Copyright (c) 2018-2019 elementary LLC. (https://github.com/elementary/vala-lint)
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

class ValaLint.Visitor : Vala.CodeVisitor {
    public Vala.ArrayList<FormatMistake?> mistake_list;

    public Checks.DoubleSemicolonCheck double_semicolon_check;
    public Checks.EllipsisCheck ellipsis_check;
    public Checks.NamingConventionCheck naming_convention_check;
    public Checks.UnnecessaryStringTemplateCheck unnecessary_string_template_check;
    public Checks.NoSpaceCheck no_space_check;

    public void set_mistake_list (Vala.ArrayList<FormatMistake?> mistake_list) {
        this.mistake_list = mistake_list;
    }

    public override void visit_source_file (Vala.SourceFile sf) {
        sf.accept_children (this);
    }

    public override void visit_namespace (Vala.Namespace ns) {
        /* namespace name may be null */
        naming_convention_check.check_camel_case (ns, ref mistake_list);

        ns.accept_children (this);
    }

    public override void visit_class (Vala.Class cl) {
        naming_convention_check.check_camel_case (cl, ref mistake_list);
        cl.accept_children (this);
    }

    public override void visit_struct (Vala.Struct st) {
        naming_convention_check.check_camel_case (st, ref mistake_list);
        st.accept_children (this);
    }

    public override void visit_interface (Vala.Interface iface) {
        naming_convention_check.check_camel_case (iface, ref mistake_list);
        iface.accept_children (this);
    }

    public override void visit_enum (Vala.Enum en) {
        naming_convention_check.check_camel_case (en, ref mistake_list);
        en.accept_children (this);
    }

    public override void visit_enum_value (Vala.EnumValue ev) {
        naming_convention_check.check_all_caps (ev, ref mistake_list);
        ev.accept_children (this);
    }

    public override void visit_error_domain (Vala.ErrorDomain edomain) {
        edomain.accept_children (this);
    }

    public override void visit_error_code (Vala.ErrorCode ecode) {
        ecode.accept_children (this);
    }

    public override void visit_delegate (Vala.Delegate d) {
        d.accept_children (this);
    }

    public override void visit_constant (Vala.Constant c) {
        naming_convention_check.check_all_caps (c, ref mistake_list);

        c.accept_children (this);
    }

    public override void visit_field (Vala.Field f) {
        naming_convention_check.check_underscore (f, ref mistake_list);

        f.accept_children (this);
    }

    public override void visit_method (Vala.Method m) {
        /* method name may be null */
        naming_convention_check.check_underscore (m, ref mistake_list);

        no_space_check.check_list (m.get_parameters (), ref mistake_list);

        /* Error types depend on the vala version. */
        //  var error_types = new Vala.ArrayList<Vala.DataType?> ();
        //  m.get_error_types (error_types);
        //  no_space_check.check_list (error_types, ref mistake_list);

        m.accept_children (this);
    }

    public override void visit_creation_method (Vala.CreationMethod m) {
        m.accept_children (this);
    }

    public override void visit_formal_parameter (Vala.Parameter p) {
        naming_convention_check.check_underscore (p, ref mistake_list);

        p.accept_children (this);
    }

    public override void visit_property (Vala.Property prop) {
        prop.accept_children (this);
    }

    public override void visit_property_accessor (Vala.PropertyAccessor acc) {
        acc.accept_children (this);
    }

    public override void visit_signal (Vala.Signal sig) {
        sig.accept_children (this);
    }

    public override void visit_constructor (Vala.Constructor c) {
        c.accept_children (this);
    }

    public override void visit_destructor (Vala.Destructor d) {
        d.accept_children (this);
    }

    public override void visit_type_parameter (Vala.TypeParameter p) {
        p.accept_children (this);
    }

    public override void visit_using_directive (Vala.UsingDirective ns) {
        ns.accept_children (this);
    }

    public override void visit_data_type (Vala.DataType type) {
        type.accept_children (this);
    }

    public override void visit_block (Vala.Block b) {
        b.accept_children (this);
    }

    public override void visit_empty_statement (Vala.EmptyStatement stmt) {
    }

    public override void visit_declaration_statement (Vala.DeclarationStatement stmt) {
        double_semicolon_check.check_statement (stmt, ref mistake_list);

        stmt.accept_children (this);
    }

    public override void visit_local_variable (Vala.LocalVariable local) {
        naming_convention_check.check_underscore (local, ref mistake_list);

        local.accept_children (this);
    }

    public override void visit_initializer_list (Vala.InitializerList list) {
        no_space_check.check_list (list.get_initializers (), ref mistake_list);

        list.accept_children (this);
    }

    public override void visit_expression_statement (Vala.ExpressionStatement stmt) {
        double_semicolon_check.check_statement (stmt, ref mistake_list);

        stmt.accept_children (this);
    }

    public override void visit_if_statement (Vala.IfStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_statement (Vala.SwitchStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_switch_section (Vala.SwitchSection section) {
        section.accept_children (this);
    }

    public override void visit_switch_label (Vala.SwitchLabel label) {
        label.accept_children (this);
    }

#if VALA_0_52
    public override void visit_loop_statement (Vala.LoopStatement stmt) {
#else
    public override void visit_loop (Vala.Loop stmt) {
#endif
        stmt.accept_children (this);
    }

    public override void visit_while_statement (Vala.WhileStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_do_statement (Vala.DoStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_for_statement (Vala.ForStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_foreach_statement (Vala.ForeachStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_break_statement (Vala.BreakStatement stmt) {
        double_semicolon_check.check_statement (stmt, ref mistake_list);

        stmt.accept_children (this);
    }

    public override void visit_continue_statement (Vala.ContinueStatement stmt) {
        double_semicolon_check.check_statement (stmt, ref mistake_list);

        stmt.accept_children (this);
    }

    public override void visit_return_statement (Vala.ReturnStatement stmt) {
        double_semicolon_check.check_statement (stmt, ref mistake_list);

        stmt.accept_children (this);
    }

    public override void visit_yield_statement (Vala.YieldStatement y) {
        y.accept_children (this);
    }

    public override void visit_throw_statement (Vala.ThrowStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_try_statement (Vala.TryStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_catch_clause (Vala.CatchClause clause) {
        clause.accept_children (this);
    }

    public override void visit_lock_statement (Vala.LockStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_unlock_statement (Vala.UnlockStatement stmt) {
        stmt.accept_children (this);
    }

#if VALA_0_50
    public override void visit_with_statement (Vala.WithStatement stmt) {
        stmt.accept_children (this);
    }
#endif

    public override void visit_delete_statement (Vala.DeleteStatement stmt) {
        stmt.accept_children (this);
    }

    public override void visit_expression (Vala.Expression expr) {
        // Expression is an abstract class
        // expr.accept_children (this);
    }

    public override void visit_array_creation_expression (Vala.ArrayCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_boolean_literal (Vala.BooleanLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_character_literal (Vala.CharacterLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_integer_literal (Vala.IntegerLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_real_literal (Vala.RealLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_regex_literal (Vala.RegexLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_string_literal (Vala.StringLiteral lit) {
        ellipsis_check.check_string_literal (lit, ref mistake_list);
        lit.accept_children (this);
    }

    public override void visit_template (Vala.Template tmpl) {
        unnecessary_string_template_check.check_template (tmpl, ref mistake_list);
        tmpl.accept_children (this);
    }

    public override void visit_tuple (Vala.Tuple tuple) {
        no_space_check.check_list (tuple.get_expressions (), ref mistake_list);

        tuple.accept_children (this);
    }

    public override void visit_null_literal (Vala.NullLiteral lit) {
        lit.accept_children (this);
    }

    public override void visit_member_access (Vala.MemberAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_method_call (Vala.MethodCall expr) {
        no_space_check.check_list (expr.get_argument_list (), ref mistake_list);

        expr.accept_children (this);
    }

    public override void visit_element_access (Vala.ElementAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_slice_expression (Vala.SliceExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_base_access (Vala.BaseAccess expr) {
        expr.accept_children (this);
    }

    public override void visit_postfix_expression (Vala.PostfixExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_object_creation_expression (Vala.ObjectCreationExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_sizeof_expression (Vala.SizeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_typeof_expression (Vala.TypeofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_unary_expression (Vala.UnaryExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_cast_expression (Vala.CastExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_named_argument (Vala.NamedArgument expr) {
        expr.accept_children (this);
    }

    public override void visit_pointer_indirection (Vala.PointerIndirection expr) {
        expr.accept_children (this);
    }

    public override void visit_addressof_expression (Vala.AddressofExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_reference_transfer_expression (Vala.ReferenceTransferExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_binary_expression (Vala.BinaryExpression expr) {
        no_space_check.check_binary_expression (expr, ref mistake_list);

        expr.accept_children (this);
    }

    public override void visit_type_check (Vala.TypeCheck expr) {
        expr.accept_children (this);
    }

    public override void visit_conditional_expression (Vala.ConditionalExpression expr) {
        expr.accept_children (this);
    }

    public override void visit_lambda_expression (Vala.LambdaExpression expr) {
        no_space_check.check_list (expr.get_parameters (), ref mistake_list);

        expr.accept_children (this);
    }

    public override void visit_assignment (Vala.Assignment a) {
        a.accept_children (this);
    }

    public override void visit_end_full_expression (Vala.Expression expr) {
        // Expression is an abstract class
        // expr.accept_children (this);
    }
}
