/* Prolog Constraints_Product_C_Polyhedron_Grid interface code: declarations.
   Copyright (C) 2001-2008 Roberto Bagnara <bagnara@cs.unipr.it>

This file is part of the Parma Polyhedra Library (PPL).

The PPL is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

The PPL is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02111-1307, USA.

For the most up-to-date information see the Parma Polyhedra Library
site: http://www.cs.unipr.it/ppl/ . */

extern "C" Prolog_foreign_return_type
  ppl_delete_Constraints_Product_C_Polyhedron_Grid(Prolog_term_ref t_ph);
extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_space_dimension(Prolog_term_ref t_nd,
                                               Prolog_term_ref t_uoe,
                                               Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_C_Polyhedron(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_NNC_Polyhedron(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Grid(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Rational_Box(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_mpz_class(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_mpq_class(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_mpz_class(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_mpq_class(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Double_Box(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_double(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_double(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Constraints_Product_C_Polyhedron_Grid(
                     Prolog_term_ref t_ph_source, Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_C_Polyhedron_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_NNC_Polyhedron_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Grid_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Rational_Box_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_mpz_class_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_mpq_class_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_mpz_class_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_mpq_class_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Double_Box_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_BD_Shape_double_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Octagonal_Shape_double_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
ppl_new_Constraints_Product_C_Polyhedron_Grid_from_Constraints_Product_C_Polyhedron_Grid_with_complexity(
                     Prolog_term_ref t_ph_source,
                     Prolog_term_ref t_ph,
                     Prolog_term_ref t_cc);

extern "C" Prolog_foreign_return_type
  ppl_new_Constraints_Product_C_Polyhedron_Grid_from_constraints(Prolog_term_ref t_clist,
						    Prolog_term_ref t_ph);
extern "C" Prolog_foreign_return_type
  ppl_new_Constraints_Product_C_Polyhedron_Grid_from_congruences(Prolog_term_ref t_clist,
						    Prolog_term_ref t_ph);
extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_swap(Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_space_dimension(Prolog_term_ref t_ph, Prolog_term_ref t_sd);
extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_affine_dimension(Prolog_term_ref t_ph, Prolog_term_ref t_sd);
extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_relation_with_constraint(Prolog_term_ref t_ph,
						 Prolog_term_ref t_c,
						 Prolog_term_ref t_r);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_relation_with_generator(Prolog_term_ref t_ph,
						 Prolog_term_ref t_c,
						 Prolog_term_ref t_r);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_relation_with_congruence(Prolog_term_ref t_ph,
						 Prolog_term_ref t_c,
						 Prolog_term_ref t_r);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_empty(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_universe(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_bounded(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_topologically_closed(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_discrete(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_topological_closure_assign(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_bounds_from_above(Prolog_term_ref t_ph,
				       Prolog_term_ref t_expr);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_bounds_from_below(Prolog_term_ref t_ph,
				       Prolog_term_ref t_expr);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_maximize(Prolog_term_ref t_ph, Prolog_term_ref t_le_expr,
		       Prolog_term_ref t_n,  Prolog_term_ref t_d,
		       Prolog_term_ref t_maxmin);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_minimize(Prolog_term_ref t_ph, Prolog_term_ref t_le_expr,
		       Prolog_term_ref t_n,  Prolog_term_ref t_d,
		       Prolog_term_ref t_maxmin);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_maximize_with_point(Prolog_term_ref t_ph,
				  Prolog_term_ref t_le_expr,
				  Prolog_term_ref t_n,
                                  Prolog_term_ref t_d,
				  Prolog_term_ref t_maxmin,
                                  Prolog_term_ref t_g);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_minimize_with_point(Prolog_term_ref t_ph,
				  Prolog_term_ref t_le_expr,
				  Prolog_term_ref t_n,
                                  Prolog_term_ref t_d,
				  Prolog_term_ref t_maxmin,
                                  Prolog_term_ref t_g);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_contains_Constraints_Product_C_Polyhedron_Grid(Prolog_term_ref t_lhs,
				   Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_strictly_contains_Constraints_Product_C_Polyhedron_Grid(Prolog_term_ref t_lhs,
				   Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_is_disjoint_from_Constraints_Product_C_Polyhedron_Grid(Prolog_term_ref t_lhs,
				   Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_equals_Constraints_Product_C_Polyhedron_Grid(Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_OK(Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_constraint(Prolog_term_ref t_ph, Prolog_term_ref t_c);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_congruence(Prolog_term_ref t_ph, Prolog_term_ref t_c);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_constraints(Prolog_term_ref t_ph,
				   Prolog_term_ref t_clist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_congruences(Prolog_term_ref t_ph,
				   Prolog_term_ref t_clist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_refine_with_constraint(Prolog_term_ref t_ph, Prolog_term_ref t_c);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_refine_with_congruence(Prolog_term_ref t_ph, Prolog_term_ref t_c);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_refine_with_constraints(Prolog_term_ref t_ph,
				   Prolog_term_ref t_clist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_refine_with_congruences(Prolog_term_ref t_ph,
				   Prolog_term_ref t_clist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_intersection_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_upper_bound_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_difference_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_concatenate_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_time_elapse_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_upper_bound_assign_if_exact
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_constrains(Prolog_term_ref t_ph,
                          Prolog_term_ref t_v);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_unconstrain_space_dimension(Prolog_term_ref t_ph,
                           Prolog_term_ref t_v);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_unconstrain_space_dimensions(Prolog_term_ref t_ph,
                           Prolog_term_ref t_vlist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_affine_image
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_le, Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_affine_preimage
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_le, Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_bounded_affine_image
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_lb_le, Prolog_term_ref t_ub_le,
   Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_bounded_affine_preimage
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_lb_le, Prolog_term_ref t_ub_le,
   Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_generalized_affine_image
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_r, Prolog_term_ref t_le,
   Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_generalized_affine_preimage
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_v, Prolog_term_ref t_r, Prolog_term_ref t_le,
   Prolog_term_ref t_d);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_generalized_affine_image_lhs_rhs
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_lhs, Prolog_term_ref t_r, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_generalized_affine_preimage_lhs_rhs
  (Prolog_term_ref t_ph,
   Prolog_term_ref t_lhs, Prolog_term_ref t_r, Prolog_term_ref t_rhs);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_space_dimensions_and_embed
  (Prolog_term_ref t_ph, Prolog_term_ref t_nnd);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_add_space_dimensions_and_project
  (Prolog_term_ref t_ph, Prolog_term_ref t_nnd);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_remove_space_dimensions
  (Prolog_term_ref t_ph, Prolog_term_ref t_vlist);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_remove_higher_space_dimensions
  (Prolog_term_ref t_ph, Prolog_term_ref t_nd);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_expand_space_dimension
  (Prolog_term_ref t_ph, Prolog_term_ref t_v, Prolog_term_ref t_nd);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_fold_space_dimensions
  (Prolog_term_ref t_ph, Prolog_term_ref t_vlist, Prolog_term_ref t_v);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_map_space_dimensions
  (Prolog_term_ref t_ph, Prolog_term_ref t_pfunc);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_ascii_dump
  (Prolog_term_ref t_ph);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_external_memory_in_bytes(Prolog_term_ref t_pps,
			 Prolog_term_ref t_m);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_total_memory_in_bytes(Prolog_term_ref t_pps,
			 Prolog_term_ref t_m);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_widening_assign_with_tokens
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs,
   Prolog_term_ref t_ti, Prolog_term_ref t_to);

extern "C" Prolog_foreign_return_type
  ppl_Constraints_Product_C_Polyhedron_Grid_widening_assign
  (Prolog_term_ref t_lhs, Prolog_term_ref t_rhs);


