%%------------------------------------------------------------------------------
%% Copyright 2014 FlowForwarding.org
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%-----------------------------------------------------------------------------

%% @author Erlang Solutions Ltd. <openflow@erlang-solutions.com>
%% @copyright 2014 FlowForwarding.org

%% @doc Header file for userspace implementation of OpenFlow switch.

-define(CAPABILITIES, [flow_stats,
                       table_stats,
                       port_stats,
                       group_stats,
                       %% ip_reasm,
                       queue_stats
                       %% port_blocked
                      ]).
-define(SUPPORTED_ACTIONS, [output,
                            group,
                            set_queue,
                            set_mpls_ttl,
                            dec_mpls_ttl,
                            set_nw_ttl,
                            dec_nw_ttl,
                            copy_ttl_out,
                            copy_ttl_in,
                            push_vlan,
                            pop_vlan,
                            push_mpls,
                            pop_mpls,
                            push_pbb,
                            pop_pbb,
                            set_field
                           ]).
-define(SUPPORTED_WRITE_ACTIONS, ?SUPPORTED_ACTIONS).
-define(SUPPORTED_APPLY_ACTIONS, ?SUPPORTED_ACTIONS).
-define(SUPPORTED_MATCH_FIELDS, [in_port,
                                 %% in_phy_port,
                                 metadata,
                                 eth_dst,
                                 eth_src,
                                 eth_type,
                                 vlan_vid,
                                 vlan_pcp,
                                 ip_dscp,
                                 ip_ecn,
                                 ip_proto,
                                 ipv4_src,
                                 ipv4_dst,
                                 tcp_src,
                                 tcp_dst,
                                 udp_src,
                                 udp_dst,
                                 sctp_src,
                                 sctp_dst,
                                 icmpv4_type,
                                 icmpv4_code,
                                 arp_op,
                                 arp_spa,
                                 arp_tpa,
                                 arp_sha,
                                 arp_tha,
                                 ipv6_src,
                                 ipv6_dst,
                                 ipv6_flabel,
                                 icmpv6_type,
                                 icmpv6_code,
                                 ipv6_nd_target,
                                 ipv6_nd_sll,
                                 ipv6_nd_tll,
                                 mpls_label,
                                 mpls_tc,
                                 mpls_bos,
                                 pbb_isid
                                 %% tunnel_id
                                 %% ext_hdr
                                ]).
-define(SUPPORTED_WILDCARDS, ?SUPPORTED_MATCH_FIELDS).
-define(SUPPORTED_WRITE_SETFIELDS, ?SUPPORTED_MATCH_FIELDS).
-define(SUPPORTED_APPLY_SETFIELDS, ?SUPPORTED_WRITE_SETFIELDS).
-define(SUPPORTED_INSTRUCTIONS, [goto_table,
                                 write_metadata,
                                 write_actions,
                                 apply_actions,
                                 clear_actions,
                                 meter]).
-define(SUPPORTED_RESERVED_PORTS, [all,
                                   controller,
                                   table,
                                   inport,
                                   any
                                   %% local
                                   %% normal
                                   %% flood
                                  ]).
-define(SUPPORTED_GROUP_TYPES, [all,
                                select,
                                indirect,
                                ff
                               ]).
-define(SUPPORTED_GROUP_CAPABILITIES, [select_weight,
                                       select_liveness,
                                       chaining
                                       %% chaining-check
                                      ]).
-define(SUPPORTED_METADATA_MATCH, <<-1:64>>).
-define(SUPPORTED_METADATA_WRITE, <<-1:64>>).

-define(MAX, (1 bsl 24)). %% some arbitrary big number
-define(MAX_FLOW_TABLE_ENTRIES, ?MAX).
-define(MAX_TABLES, 255).
-define(MAX_BANDS, 255).
-define(MAX_PORTS, ?MAX).
-define(MAX_BUFFERED_PACKETS, 0).

-type table_id() :: non_neg_integer().
-type priority() :: non_neg_integer().
-type flow_id() :: reference().

-type linc_table_config() :: continue
                           | drop
                           | controller.

-record(flow_table_config, {
          id            :: table_id(),
          config = drop :: linc_table_config()
         }).

-record(flow_entry, {
          id                       :: flow_id(),
          datapath_id              :: datapath_id(),
          table_id                 :: table_id(),
          priority                 :: priority(),
          match = #ofp_match{}     :: ofp_match(),
          cookie = <<0:64>>        :: binary(),
          flags = []               :: [ofp_flow_mod_flag()],
          expires = {infinity,0,0} :: erlang:timestamp(),
          idle = {infinity,0,0}    :: erlang:timestamp(),
          instructions = []        :: [ofp_instruction()]
         }).
-type flow_entry() :: #flow_entry{}.
