package kr.sm.ltaewon.travelmaker.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Article {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="article_id")
    private int id;

    @JoinColumn(name="location_id")
    @ManyToOne(targetEntity = Location.class, fetch = FetchType.LAZY)
    private Location location;

    @Column(name="image")
    private String image;

    @Column(name="summary")
    private String summary;

    @Column(name="link")
    private String link;

}
