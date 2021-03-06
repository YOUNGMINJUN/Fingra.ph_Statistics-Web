/**
 * Copyright 2014 tgrape Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package ph.fingra.statisticsweb.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import ph.fingra.statisticsweb.domain.Member;

@Repository
public class MemberDaoImpl implements MemberDao {
    
    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;
    
    public void insert(Member member) {
        sqlSessionTemplate.insert("member.insert", member);
    }
    
    public void update(Member member) {
        sqlSessionTemplate.update("member.update", member);
    }
    
    public void updateByAdmin(Member member) {
        sqlSessionTemplate.update("member.updateByAdmin", member);
    }
    
    public void updateStatus(Member member) {
        sqlSessionTemplate.update("member.updateStatus", member);
    }
    
    public void updateJoinstatus(Member member) {
        sqlSessionTemplate.update("member.updateJoinstatus", member);
    }
    
    public void updatePassword(Member member) {
        sqlSessionTemplate.update("member.updatePassword", member);
    }
    
    public void delete(String email) {
        sqlSessionTemplate.delete("member.delete", email);
    }
    
    public void updateMemberLastLoginTime(Member member) {
        sqlSessionTemplate.update("member.updateMemberLastLoginTime", member);
    }
    
    public List<Member> getList() {
        return sqlSessionTemplate.selectList("member.getList");
    }
    
    public List<Member> getListByStatus(int status) {
        return sqlSessionTemplate.selectList("member.getListByStatus", status);
    }
    
    public List<Member> getListByJoinstatus(int joinstatus) {
        return sqlSessionTemplate.selectList("member.getListByJoinstatus", joinstatus);
    }
    
    public Member findByEmail(String email) {
        return sqlSessionTemplate.selectOne("member.findByEmail", email);
    }
    
    public int countByEmail(String email) {
        return sqlSessionTemplate.selectOne("member.countByEmail", email);
    }
    
    public Member findById(Integer memberid) {
        return sqlSessionTemplate.selectOne("member.findById", memberid);
    }
}
